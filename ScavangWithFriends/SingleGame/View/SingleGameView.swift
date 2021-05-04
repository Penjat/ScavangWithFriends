import SwiftUI
import SwiftUICameraService

struct SingleGameView: View {
	@StateObject var interactor  = RealSingleGameInteractor()
	@State private var selectedTab = 0
	@State private var selectedImage: UIImage?
	@State private var cameraFront = false
	
	var body: some View {
		switch interactor.viewState.gameState {
		case .over:
			Text("Game over")
		case .playing:
			ZStack {
				SwiftUICameraService.CameraPreview(session: interactor.session).onAppear{
					interactor.processInput(.configure)
				}
				VStack() {
					Text("\(selectedTab)")
					Button(action: { }){
						Text("take photo \(interactor.viewState.unPhotoed[selectedTab])")
					}
					Spacer()

					Picker("", selection: $selectedTab){
						ForEach(interactor.viewState.unPhotoed, id: \.self) { clue in
							Text(clue)
						}
					}
					.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
					.frame(width: UIScreen.main.bounds.width/2, height: 200, alignment: .bottom)
				}.navigationBarItems(trailing: Button("Flip"){
//					service.changeCamera()
				})
//				if service.photo != nil {
//					Image(uiImage: service.photo!.image!)
//						.resizable()
//						.aspectRatio(contentMode: .fill)
//						.frame(width: 60, height: 60)
//						.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//						.animation(.spring())
//
//				} else {
//					RoundedRectangle(cornerRadius: 10)
//						.frame(width: 60, height: 60, alignment: .center)
//						.foregroundColor(.black)
//				}
			}
		}
	}
}

struct SingleGameView_Previews: PreviewProvider {
	static var previews: some View {
		SingleGameView()
	}
}
