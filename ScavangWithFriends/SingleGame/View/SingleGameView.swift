import SwiftUI

struct SingleGameView: View {
	@StateObject var interactor  = RealSingleGameInteractor()
	@State private var selectedTab = 0
	
	var body: some View {
		VStack() {
			Text("\(selectedTab)")
			Button(action: { interactor.processInput(.takePhoto(interactor.viewState.unPhotoed[selectedTab]))}){
				Text("take photo \(interactor.viewState.unPhotoed[selectedTab])")
			}
			Spacer()
			Picker("", selection: $selectedTab){
				ForEach(interactor.viewState.unPhotoed, id: \.self) { clue in
					Text(clue)
				}
			}
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
			.frame(width: UIScreen.main.bounds.width, height: 200, alignment: .bottom)
		}
	}
}

struct SingleGameView_Previews: PreviewProvider {
	static var previews: some View {
		SingleGameView()
	}
}
