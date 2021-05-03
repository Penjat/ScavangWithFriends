import Foundation

typealias Clue = String

class SingleGame {
	var clues: [Clue: ResponseState]
	init(clues: [Clue: ResponseState]) {
		self.clues = clues
	}

	var remainingClues: [Clue: ResponseState] {
		clues.filter{
			switch $0.value {
			case .none:
				return true
			default:
				return false
			}
		}
	}

	func tookPhoto(key: Clue, photoURL: URL) {
		if clues.contains(where: {(k,_) in k == key}){
			clues[key] = ResponseState.photoTaken(photoURL)
		}
	}

	func gradedPhoto(key: Clue, photoURL: URL, response: ScavangResponse) {
		if clues.contains(where: {(k,_) in k == key}){
			clues[key] = ResponseState.photoGraded(photoURL, response)
		}
	}
}

enum ResponseState {
	case none
	case photoTaken(URL)
	case photoGraded(URL, ScavangResponse)
}

struct ScavangResponse {
	let score: Int
}
