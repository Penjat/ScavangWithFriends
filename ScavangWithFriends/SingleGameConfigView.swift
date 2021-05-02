import SwiftUI

struct SingleGameConfigView: View {
    var body: some View {


			NavigationLink(destination: SingleGameView()) { Text("Start Game") }

    }
}

struct SingleGameConfigView_Previews: PreviewProvider {
    static var previews: some View {
        SingleGameConfigView()
    }
}
