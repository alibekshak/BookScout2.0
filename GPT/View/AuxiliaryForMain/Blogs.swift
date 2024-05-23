import SwiftUI


struct Blog: View {
    
    @StateObject var vm: ChatBlogsViewModel
    
    @Binding var isActive: Bool
    
    var image: String
    var text: String
    var text_send: String
    
    var body: some View {
        VStack(alignment: .center) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(text)
                .font(.title3)
                .fontWeight(.black)
                .foregroundColor(Color.black.opacity(0.8))
                .padding(.bottom)
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(CustomColors.strokeColor, lineWidth: 1)
        )
        .padding([.top, .horizontal])
        .onTapGesture {
            sendTextBlog()
        }
    }
    
    private func sendTextBlog() {
        Task {
            await vm.send(text: text_send)
            isActive = true
        }
    }
}


