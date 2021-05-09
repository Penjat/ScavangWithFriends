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

	var body: some View {
		ZStack{
			ScrollView{
				titleView
				Divider()
				Text("How to play:").font(.title2).foregroundColor(.orange).underline()
				howToPLay.padding()
				Divider()
				LevelOne()
			}
			CameraPreview(session: interactor.cameraService.session)
				.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
				.foregroundColor(.blue)
				.onAppear{
					self.interactor.processInput(.configureCamera)
				}
		}
	}
}

struct MainStreamView_Previews: PreviewProvider {
	static var previews: some View {
		MainStreamView()
	}
}
