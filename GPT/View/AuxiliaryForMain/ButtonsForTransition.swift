import SwiftUI

struct ButtonsForTransition<Destination: View>: View {
    var destination: Destination
    var image: String
    var title: String
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                Image(image)
                    .resizable()
                    .frame(width: 320, height: 170)
                    .clipped()
                Text(title)
                    .font(.headline)
                    .fontWeight(.black)
                    .foregroundColor(Color.black.opacity(0.8))
                    .padding(.bottom)
            }
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(CustomColors.strokeColor, lineWidth: 1)
            )
            .padding()
        }
    }
}


