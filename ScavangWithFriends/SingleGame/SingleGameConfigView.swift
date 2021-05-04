import SwiftUI

struct SingleGameConfigView: View {
    var body: some View {
		VStack(){
			NavigationLink(destination: SingleGameView()) { Text("Start Game") }
		}.navigationTitle(Text("Config Single Game"))
    }
}

struct SingleGameConfigView_Previews: PreviewProvider {
    static var previews: some View {
        SingleGameConfigView()
    }
}
