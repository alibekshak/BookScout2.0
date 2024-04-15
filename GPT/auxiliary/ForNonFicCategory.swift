import SwiftUI


struct CategoryNonFic: View{
    var vm: ChatCategoryViewModel
    @Binding var isActive: Bool
    var title: String
    var text: String
    var text2: String
    var text3: String
    var text_send: String
    
    var body: some View{
        ZStack {
            Color.white
            NavigationLink(destination: ChatCategoryView(vm: vm)){
                HStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        Text(text)
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.6))
                        Text(text2)
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.6))
                        Text(text3)
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.6))
                        
                    }
                    .layoutPriority(110)
                    
                    Spacer()
                }
                .padding()
            }
            .simultaneousGesture(TapGesture().onEnded {
                sendCategory()
            })
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.6), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
    private func sendCategory(){
        Task{
            await vm.send(text: text_send)
            isActive = true
        }
    }
}




