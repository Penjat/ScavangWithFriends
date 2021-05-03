import SwiftUI

struct SingleGameView: View {
	@StateObject var interactor  = RealSingleGameInteractor()
	@State private var selectedTab = 0
	
	var body: some View {
		VStack() {
			Text("\(selectedTab)")
			Button(action: { interactor.processInput(.takePhoto)}){
				Text("take photo")
			}
			Spacer()
			TabView(selection: $selectedTab){
				ForEach(0..<interactor.viewState.unPhotoed.count) { index in
					Text(interactor.viewState.unPhotoed[index]).tag(index)
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
