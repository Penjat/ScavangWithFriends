import SwiftUI

struct TitleMenuView: View {
    var body: some View {
		NavigationView(content: {
			VStack(){
				Text("SCAVANG with FRIENDS").font(.title).padding()
				NavigationLink(destination: SingleGameConfigView()) { Text("single player") }
			}
		})
    }
}

struct TitleMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TitleMenuView()
    }
}
