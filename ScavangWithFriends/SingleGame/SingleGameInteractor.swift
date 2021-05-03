
import Combine

protocol SingleGameInteractor {
	func processInput(_ intent: SingleGameIntent)
	var viewStatePublisher: Published<SingleGameViewState>.Publisher { get }
}

// MARK: - Implemetation
class RealSingleGameInteractor: SingleGameInteractor, ObservableObject {
	var viewStatePublisher: Published<SingleGameViewState>.Publisher { $viewState }
	@Published var viewState: SingleGameViewState = SingleGameViewState(unPhotoed: ["go","bo"])
	private var bag = Set<AnyCancellable>()
	private let intents = PassthroughSubject<SingleGameIntent, Never>()
	//MARK: - LifeCycle
	init() {
		resultsToViewState()
	}

	deinit {
		bag.removeAll()
	}


	//MARK: - Input
	public func processInput(_ intent: SingleGameIntent) {
		intents.send(intent)
	}

	//MARK: - Side Effects
	private enum SingleGameResult {
		case updateUnPhotoed([String])
	}

	private lazy var results = intents.flatMap { (intent) -> Publishers.Sequence<[SingleGameResult], Never> in
		print("intent recieved")
		switch intent {
		case .takePhoto:
			print("subitted photo")
			return [].publisher
		}
	}.share()

	private func resultsToViewState() {
		results.sink{ result in
			switch result {
			case .updateUnPhotoed(let _):
				print("result to state")
			}
		}.store(in: &bag)
	}
}
