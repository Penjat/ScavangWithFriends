import Foundation

//MARK: Input
enum SingleGameViewIntent {
	case takePhoto(String)
	case configure
	case flipCamera
}

//MARK: Output
struct SingleGameViewState {
	let gameState: GameState
	let unPhotoed: [String]
}

enum GameState {
	case playing
	case over
}
