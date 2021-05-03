import XCTest

class ScavangWithFriendsTests: XCTestCase {

    func testSingleGameNoClues() {
		///Given
		let clues: [String: ResponseState] = [:]
		let singleGame = SingleGame(clues: clues)

		///Then
		XCTAssertEqual(singleGame.clues.count, 0)
	}

	func testSingleGameFiveClues() {
		///Given
		let clues = ["chair":ResponseState.none,
					 "apple":ResponseState.none,
					 "bucket":ResponseState.none,
					 "broom":ResponseState.none,
					 "banana":ResponseState.none]
		let singleGame = SingleGame(clues: clues)

		///Then
		XCTAssertEqual(singleGame.clues.count, 5)
	}


}
