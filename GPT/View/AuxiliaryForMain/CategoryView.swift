import SwiftUI

struct CategoryView: View{
    @StateObject var vm: ChatCategoryViewModel
    
    @Binding  var isActive: Bool
    
    var title: String
    var text: String
    var text_send: String
    
    var body: some View{
        NavigationLink(destination: ChatCategoryView(vm: vm)){
            ZStack {
                Color.white
                    VStack(alignment: .leading, spacing: 12) {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.black)
                            .foregroundColor(.black)
                        Text(text)
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.6))
                            .multilineTextAlignment(.leading)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .simultaneousGesture(TapGesture().onEnded {
                sendCategory()
            })
        }
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
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

