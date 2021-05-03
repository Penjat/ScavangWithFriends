
import Combine

protocol SingleGameInteractor {
	func processInput(_ intent: SingleGameIntent)
	//	var viewState:  AnyCancellable { get }
}

// MARK: - Implemetation
class RealSingleGameInteractor: SingleGameInteractor, ObservableObject {

//	@published unphotoedArray;

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
}

//MARK: I/O
enum SingleGameIntent {
	case submitPhoto
}

enum SingleGameResult {
	case updateUnPhotoed([String])
}
