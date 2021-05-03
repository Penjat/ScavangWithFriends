
import Combine

protocol SingleGameInteractor {
	func processInput(_ intent: SingleGameIntent)
	//	var viewState:  AnyCancellable { get }
}

// MARK: - Implemetation
class RealSingleGameInteractor: SingleGameInteractor, ObservableObject {

	@Published var unphotoedArray = ["hi"]
	var bag = Set<AnyCancellable>()
	//MARK: - Input
	let intents = PassthroughSubject<SingleGameIntent, Never>()

	func processInput(_ intent: SingleGameIntent) {
		intents.send(intent)
	}

	//MARK: - Side Effects
	lazy var results = intents.flatMap { (intent) -> Publishers.Sequence<[SingleGameResult], Never> in
		print("intent recieved")
		switch intent {
		case .submitPhoto:
			print("subitted photo")
			return [].publisher
		}
	}.share()

	init() {
		let _ = results.sink{ result in
			switch result {
			case .updateUnPhotoed(let unPhotoed):
				print("result to state")
			}
		}.store(in: &bag)
	}

	deinit {
		bag.removeAll()
	}

	@Published var viewState: SingleGameViewState = SingleGameViewState()
}

//MARK: I/O
enum SingleGameIntent {
	case submitPhoto
}

enum SingleGameResult {
	case updateUnPhotoed([String])
}

struct SingleGameViewState {

}
