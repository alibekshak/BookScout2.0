import SwiftUI

struct ButtonsForTransition<Destination: View>: View {
    var destination: Destination
    var image: String
    var title: String
    
    var body: some View {
        VStack{
            NavigationLink(destination: destination) {
                Image(image)
                    .resizable()
                    .frame(width: 320, height: 170)
                    .clipped()
            }
            NavigationLink(destination: destination) {
                HStack{
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.black)
                            .foregroundColor(Color.black.opacity(0.8))
                            .lineLimit(1)
                    }
                    .offset(y: -5)
                }
                .padding()
            }
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.7), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}


