import SwiftUI

// home screen, app title and two buttons
struct ContentView: View {
    var body: some View {
        // to open different screens
        NavigationStack {
            // vertical spacing
            VStack(spacing: 30) {
                
                // app's icon
                Image(systemName: "paintbrush")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                // adding a gradient design
                    .foregroundStyle(.linearGradient(colors: [.yellow, .pink], startPoint: .top, endPoint: .bottom))
                // app title
                Text("Random Art")
                    .font(.largeTitle)
                
                Text("Experiment with grids of \n colored shapes and symbols. \n Create your own random artwork!")
                    .foregroundStyle(.secondary)
                // justifying the text
                    .multilineTextAlignment(.center)
                
                // a reference to Geometry Dash game :)
                // navigation link button opens another view
                NavigationLink("Geometry Mesh") {
                    GeometryMesh()
                }
                // filled button
                .buttonStyle(.borderedProminent)
                
                NavigationLink("Weather Guesser") {
                    WeatherGuesser()
                }
                .buttonStyle(.borderedProminent)
            }
            // space around the whole v stack
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
