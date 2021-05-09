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
			return [].publisher
		case .configureCamera:
			print("configuring camera")
			self.cameraService.checkForPermissions()
			self.cameraService.configure()
			return [].publisher
		}
	}.share()

	//MARK: - Output

	private func resultsToViewState() {
		results.sink{ result in
			switch result {
			case .updateCounter(_):
				break
			}
		}.store(in: &bag)
	}
}

//MARK: I/O
enum MainStreamViewIntent {
	case pressedButton
	case configureCamera
}

enum MainStreamResult {
	case updateCounter(String)
}

struct MainStreamViewState {
	var msgText: String
	static var initial: MainStreamViewState {
		return MainStreamViewState(msgText: "Initial Text")
	}
}
