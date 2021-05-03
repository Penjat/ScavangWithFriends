import SwiftUI

struct SingleGameView: View {
	@StateObject var interactor = RealSingleGameInteractor()
	@State private var selectedTab = 0
	var body: some View {
		VStack() {
			Text("\(selectedTab)")
			Button(action: { interactor.processInput(.submitPhoto)}){
				Text("take photo")
			}
			Spacer()
			TabView(selection: $selectedTab){
				ForEach(0..<interactor.unphotoedArray.count) { index in
					Text(interactor.unphotoedArray[index]).tag(index)
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
