import SwiftUI

struct LevelOne: View {
    var body: some View {
        VStack(spacing: 60){
			Text("Starts with A").font(.title3)
			Text("Something Cold").font(.title3)
			Text("Feed the horses something").font(.title3)
		}
    }
}

struct LevelOne_Previews: PreviewProvider {
    static var previews: some View {
        LevelOne()
    }
}
