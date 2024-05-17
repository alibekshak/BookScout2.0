import SwiftUI

struct CategoryView: View{
    @StateObject var vm: ChatCategoryViewModel
    
    @Binding  var isActive: Bool
    
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
                            .foregroundColor(.black)
                        VStack(alignment: .leading) {
                            Text(text)
                            Text(text2)
                            Text(text3)
                        }
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.6))
                    }
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
                .stroke(CustomColors.strokeColor, lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
    
    private func sendCategory() {
        Task {
            await vm.send(text: text_send)
            isActive = true
        }
    }
}

