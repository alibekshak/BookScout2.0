import SwiftUI


struct Blog: View {
    
    @StateObject var vm: ChatBlogsViewModel
    
    @Binding var isActive: Bool
    
    var image: String
    var text2: String
    var text3: String?
    var text_send: String
    
    var body: some View {
        VStack {
            NavigationLink(destination: ChatBlogsView(vm: vm)) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .simultaneousGesture(TapGesture().onEnded {
                sendTextBlog()
            })
            NavigationLink(destination: ChatBlogsView(vm: vm)) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(text2)
                            .font(.title3)
                            .fontWeight(.black)
                            .foregroundColor(Color.black.opacity(0.8))
                            .lineLimit(2)
                        if let text3 = text3 {
                            Text(text3)
                                .font(.title3)
                                .fontWeight(.black)
                                .foregroundColor(Color.black.opacity(0.8))
                        }
                    }
                    .offset(y: -5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                }
                .padding()
            }
            .simultaneousGesture(TapGesture().onEnded {
                sendTextBlog()
            })
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
    
    private func sendTextBlog() {
        Task {
            await vm.send(text: text_send)
            isActive = true
        }
    }
}


