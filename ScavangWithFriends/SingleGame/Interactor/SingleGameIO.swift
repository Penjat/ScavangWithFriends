import Foundation

//MARK: Input
enum SingleGameViewIntent {
	case takePhoto(String)
}

//MARK: Output
struct SingleGameViewState {
	let unPhotoed: [String]
}
