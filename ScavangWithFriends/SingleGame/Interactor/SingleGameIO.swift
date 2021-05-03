import Foundation

//MARK: Input
enum SingleGameViewIntent {
	case takePhoto
}

//MARK: Output
struct SingleGameViewState {
	let unPhotoed: [String]
}
