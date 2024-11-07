import SwiftUI

struct ContentView: View {
    var body: some View {
        Card {
            VStack{
                Image("BBSS")
                    .resizable()
                    .scaledToFit()
                    .frame(height:150)
                Text("Robotics Club VIA")
                Image(systemName: "person.text.rectangle.fill")
                    .font(.largeTitle)
            }
        }
    }
}
