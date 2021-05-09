import Combine
import SwiftUICameraService
import UIKit

protocol MainStreamInteractor {
	func processInput(_ intent: MainStreamViewIntent)
	//	var viewState:  AnyCancellable { get }
}

// MARK: - Implemetation
class RealMainStreamInteractor: MainStreamInteractor, ObservableObject {
	let cameraService = CameraService()
	private var bag = Set<AnyCancellable>()
	@Published var viewState: MainStreamViewState

	public init() {
		viewState = MainStreamViewState.initial
		resultsToViewState()
		self.cameraService.checkForPermissions()
		self.cameraService.configure()
	}

	deinit {
		bag.removeAll()
	}

	//MARK: - Input
	let intents = PassthroughSubject<MainStreamViewIntent, Never>()

	func processInput(_ intent: MainStreamViewIntent) {
		intents.send(intent)
	}

	//MARK: - Side Effects
	lazy var results = intents.flatMap { (intent) -> Publishers.Sequence<[MainStreamResult], Never> in
		print("intent recieved")
		switch intent {
		case .pressedButton:
			print("pressed button")
			return [.openCamera].publisher
		case .closeCamera:
			return [.closeCamera].publisher
		case .takePic:
			self.cameraService.capturePhoto()
			return[].publisher
		}
	}.merge(with: cameraService.$photo.compactMap{ photo in
		guard let photo = photo else {
			return nil
		}
		return .pictureTaken(photo)

	}).share()

	//MARK: - Output

	private func resultsToViewState() {
		results.sink{ result in
			switch result {
			case .openCamera:
				self.viewState = MainStreamViewState(cameraState: .scanFor("whatever"), msgText: "hi")
			case .closeCamera:
				self.viewState = MainStreamViewState(cameraState: .hide, msgText: "hi")
			case .pictureTaken(let photo):
				if let image = photo.image {
					self.viewState = MainStreamViewState(cameraState: .checking(image), msgText: "hi")
				}
			}
		}.store(in: &bag)
	}
}

//MARK: I/O
enum MainStreamViewIntent {
	case pressedButton
	case closeCamera
	case takePic
}

enum MainStreamResult {
	case openCamera
	case closeCamera
	case pictureTaken(Photo)
}

struct MainStreamViewState {
	let cameraState: CameraState
	enum CameraState {
		case hide
		case scanFor(String)
		case checking(UIImage)
		case done(String)
	}
	var msgText: String
	static var initial: MainStreamViewState {
		return MainStreamViewState(cameraState: .hide, msgText:"Initial Text")
	}
}
