import SwiftUI

struct TitleMenuView: View {
    var body: some View {
		NavigationView(content: {
			NavigationLink(destination: SingleGameConfigView()) { /*@START_MENU_TOKEN@*/Text("Navigate")/*@END_MENU_TOKEN@*/ }
		})
    }
}

struct TitleMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TitleMenuView()
    }
}
