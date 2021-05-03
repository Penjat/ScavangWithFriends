import Foundation

//MARK: Input
enum SingleGameIntent {
	case takePhoto
}

//MARK: Output
struct SingleGameViewState {
	let unPhotoed: [String]
}
