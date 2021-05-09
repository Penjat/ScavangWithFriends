import Combine
import SwiftUICameraService

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
		case .configureCamera:
			print("configuring camera")
			self.cameraService.checkForPermissions()
			self.cameraService.configure()
			return [].publisher
		case .closeCamera:
			return [.closeCamera].publisher
		}
	}.share()

	//MARK: - Output

	private func resultsToViewState() {
		results.sink{ result in
			switch result {
			case .openCamera:
				self.viewState = MainStreamViewState(cameraState: .scanFor("whatever"), msgText: "hi")
			case .closeCamera:
				self.viewState = MainStreamViewState(cameraState: .hide, msgText: "hi")
			}
		}.store(in: &bag)
	}
}

//MARK: I/O
enum MainStreamViewIntent {
	case pressedButton
	case configureCamera
	case closeCamera
}

enum MainStreamResult {
	case openCamera
	case closeCamera
}

struct MainStreamViewState {
	let cameraState: CameraState
	enum CameraState {
		case hide
		case scanFor(String)
		case checking
		case done(String)
	}
	var msgText: String
	static var initial: MainStreamViewState {
		return MainStreamViewState(cameraState: .hide, msgText:"Initial Text")
	}
}
