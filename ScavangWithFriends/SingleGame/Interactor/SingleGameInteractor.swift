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
		viewState = SingleGameViewState(gameState: .playing, unPhotoed: game.remainingClues.map{$0.key})
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
		case gameOver
	}

	private lazy var results = intents.flatMap { (intent) -> Publishers.Sequence<[SingleGameResult], Never> in
		print("intent recieved")
		switch intent {
		case .takePhoto(let key):
			self.game.tookPhoto(key: key, photoURL: URL(string: "www.google.com")!)
			let remainingClues = self.game.remainingClues.map{$0.key}
			if remainingClues.isEmpty {
				return [.gameOver].publisher
			}
			return [.updateUnPhotoed(remainingClues)].publisher
		}
	}.share()

	private func resultsToViewState() {
		results.sink{ result in
			switch result {
			case .updateUnPhotoed(let remainingClues):
				print("updating state")
				self.viewState = SingleGameViewState(gameState: .playing, unPhotoed: remainingClues)
			case .gameOver:
				self.viewState = SingleGameViewState(gameState: .over, unPhotoed: [])
			}
		}.store(in: &bag)
	}
}
