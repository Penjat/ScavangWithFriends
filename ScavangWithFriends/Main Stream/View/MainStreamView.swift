import SwiftUI
import SwiftUICameraService

struct MainStreamView: View {
	@StateObject var interactor = RealMainStreamInteractor()
	var titleView: some View {
		VStack{
			Text("Camera Quest").font(.title)
			Text("or").font(.caption)
			Text("Scavange with Friends").font(.title)
		}.frame(width: UIScreen.main.bounds.width, height: 600, alignment: .center)
	}


	var howToPLay: some View {
		
		Text("Take a picture of things around you to complete your Quest.").foregroundColor(.gray)
	}

	var gameView: some View {
		ScrollView{
			titleView
			Divider()
			Text("How to play:").font(.title2).foregroundColor(.orange).underline()
			howToPLay.padding()
			Divider()
			Button("Feed the horses"){
				interactor.processInput(.pressedButton)
			}
		}
	}

	var cameraView: some View {
		ZStack {
			VStack{
				Button("x") {
					interactor.processInput(.closeCamera)
				}
				CameraPreview(session: interactor.cameraService.session)
					.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
				Button("take pic") {
					interactor.processInput(.takePic)
				}
			}
		}
	}

	var body: some View {
			switch interactor.viewState.cameraState {
			case .scanFor(let _):
				ZStack {
					gameView
					cameraView
				}
			case .checking(let image):
				ZStack {
					gameView
					Image(uiImage: image).resizable().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
					ProgressView().progressViewStyle(CircularProgressViewStyle())
				}
			case .done(let image, let indentifiedAs):
				ZStack {
					gameView
					Image(uiImage: image).resizable().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
					Text(indentifiedAs)
				}
			default:
				gameView

		}
	}
}

struct MainStreamView_Previews: PreviewProvider {
	static var previews: some View {
		MainStreamView()
	}
}
