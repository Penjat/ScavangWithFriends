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
	let mlService = ImageScanner()
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
			return[].publisher//TODO could return loading
		}
	}.merge(with: mlService.$output.flatMap { result -> Publishers.Sequence<[MainStreamResult], Never> in
		switch result {
		case .sucess:
			print("recieved sucess result")
			guard let image = self.cameraService.photo?.image else {
				return [].publisher
				}
			return [.pictureScanned(image, "ur pic was scanned")].publisher
		case .nothing:
			return [].publisher
		case .error:
			return [].publisher
		}
	}, cameraService.$photo.flatMap{ photo -> Publishers.Sequence<[MainStreamResult], Never> in
		guard let photo = photo, let image = photo.image else {
			return [].publisher
		}
		self.mlService.processImage(image: image)
		return [.pictureTaken(photo)].publisher

	})

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
			case .pictureScanned(let image, let response):
				self.viewState = MainStreamViewState(cameraState: .done(image, response), msgText: "hi")
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
	case pictureScanned(UIImage, String)
}

struct MainStreamViewState {
	let cameraState: CameraState
	enum CameraState {
		case hide
		case scanFor(String)
		case checking(UIImage)
		case done(UIImage, String)
	}
	var msgText: String
	static var initial: MainStreamViewState {
		return MainStreamViewState(cameraState: .hide, msgText:"Initial Text")
	}
}
