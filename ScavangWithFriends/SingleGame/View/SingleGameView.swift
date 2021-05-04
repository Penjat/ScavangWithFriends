import SwiftUI

struct SingleGameView: View {
	@StateObject var interactor  = RealSingleGameInteractor()
	@State private var selectedTab = 0

	@State private var sourceType: UIImagePickerController.SourceType = .camera
	   @State private var selectedImage: UIImage?
	   @State private var isImagePickerDisplay = false
	
	var body: some View {
		switch interactor.viewState.gameState {
		case .over:
			Text("Game over")
		case .playing:
			ZStack {
				ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
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
	}
}

struct SingleGameView_Previews: PreviewProvider {
	static var previews: some View {
		SingleGameView()
	}
}
