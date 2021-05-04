import SwiftUI
import SwiftUICameraService

struct SingleGameView: View {
	@StateObject var interactor  = RealSingleGameInteractor()
	@State private var selectedTab = 0
	@State private var selectedImage: UIImage?
	@State private var cameraFront = false

	let service = SwiftUICameraService.CameraService()
	
	var body: some View {
		switch interactor.viewState.gameState {
		case .over:
			Text("Game over")
		case .playing:
			ZStack {
				SwiftUICameraService.CameraPreview(session: service.session).onAppear{
					service.checkForPermissions()
					service.configure()
				}
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
					.frame(width: UIScreen.main.bounds.width/2, height: 200, alignment: .bottom)
				}.navigationBarItems(trailing: Button("Flip"){
					cameraFront = !cameraFront
					service.changeCamera()
					print("camera = \(cameraFront)")
				})
			}
		}
	}
}

struct SingleGameView_Previews: PreviewProvider {
	static var previews: some View {
		SingleGameView()
	}
}
