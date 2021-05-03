import XCTest

class ScavangWithFriendsTests: XCTestCase {

    func testSingleGameNoClues() {
		///Given
		let clues: [String: ResponseState] = [:]
		let singleGame = SingleGame(clues: clues)

		///Then
		XCTAssertEqual(singleGame.clues.count, 0)
		XCTAssertEqual(singleGame.remainingClues.count, 0)
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
		XCTAssertEqual(singleGame.remainingClues.count, 5)
	}


	func testSingleGameFiveCluesTakePhotoExpectFourClues() {
		/// Given
		let clues = ["chair":ResponseState.none,
					 "apple":ResponseState.none,
					 "bucket":ResponseState.none,
					 "broom":ResponseState.none,
					 "banana":ResponseState.none]
		let singleGame = SingleGame(clues: clues)

		///When
		singleGame.tookPhoto(key: "chair", photoURL: URL(string: "www.google.com")!)

		///Then
		XCTAssertEqual(singleGame.clues.count, 5)
		XCTAssertEqual(singleGame.remainingClues.count, 4)
	}

	func testSingleGameFiveCluesTakePhotoTwiceExpectThreeClues() {
		/// Given
		let clues = ["chair":ResponseState.none,
					 "apple":ResponseState.none,
					 "bucket":ResponseState.none,
					 "broom":ResponseState.none,
					 "banana":ResponseState.none]
		let singleGame = SingleGame(clues: clues)

		///When
		singleGame.tookPhoto(key: "apple", photoURL: URL(string: "www.google.com")!)
		singleGame.tookPhoto(key: "broom", photoURL: URL(string: "www.google.com")!)

		///Then
		XCTAssertEqual(singleGame.clues.count, 5)
		XCTAssertEqual(singleGame.remainingClues.count, 3)
	}
}
