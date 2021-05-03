import SwiftUI

struct SingleGameView: View {
	@StateObject
	@State private var selectedTab = 0
	let things = ["elephant", "pig", "chair", "ball", "cat", "rabbit"]
	var body: some View {
		VStack() {
			Text("\(selectedTab)")
			Spacer()
			TabView(selection: $selectedTab){
				ForEach(0..<things.count) { index in
					Text(things[index]).tag(index)
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
