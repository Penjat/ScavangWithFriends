import Foundation
import Combine

protocol SingleGameInteractor {
	func processInput(_ intent: SingleGameViewIntent)
	var viewStatePublisher: Published<SingleGameViewState>.Publisher { get }
}

// MARK: - Implemetation
class RealSingleGameInteractor: SingleGameInteractor, ObservableObject {
	var viewStatePublisher: Published<SingleGameViewState>.Publisher { $viewState }
	@Published var viewState: SingleGameViewState

	private let game = SingleGame(clues: [
									"chair":ResponseState.none,
									"apple":ResponseState.none,
									"bucket":ResponseState.none,
									"broom":ResponseState.none,
									"banana":ResponseState.none])

	private var bag = Set<AnyCancellable>()
	private let intents = PassthroughSubject<SingleGameViewIntent, Never>()
	//MARK: - LifeCycle
	init() {
		viewState = SingleGameViewState(unPhotoed: game.remainingClues.map{$0.key})
		resultsToViewState()
	}

	deinit {
		bag.removeAll()
	}


	//MARK: - Input
	public func processInput(_ intent: SingleGameViewIntent) {
		intents.send(intent)
	}

	//MARK: - Side Effects
	private enum SingleGameResult {
		case updateUnPhotoed([String])
	}

	private lazy var results = intents.flatMap { (intent) -> Publishers.Sequence<[SingleGameResult], Never> in
		print("intent recieved")
		switch intent {
		case .takePhoto(let key):
			self.game.tookPhoto(key: key, photoURL: URL(string: "www.google.com")!)
			return [.updateUnPhotoed(self.game.remainingClues.map{$0.key})].publisher
//					return [.updateUnPhotoed(["hi","hi","hi","hi","hi"])].publisher
		}
	}.share()

	private func resultsToViewState() {
		results.sink{ result in
			switch result {
			case .updateUnPhotoed(let remainingClues):
				print("updating state")
				self.viewState = SingleGameViewState(unPhotoed: remainingClues)
			}
		}.store(in: &bag)
	}
}
