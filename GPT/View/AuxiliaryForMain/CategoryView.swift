import SwiftUI

struct CategoryView: View{
    @StateObject var vm: ChatCategoryViewModel
    
    @Binding  var isActive: Bool
    
    @State var isChatPresented: Bool = false
    
    var title: String
    var text: String
    var text_send: String
    
    var body: some View{
        Button {
            withAnimation {
                isChatPresented = true
                sendCategory()
            }
        } label: {
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
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(CustomColors.strokeColor, lineWidth: 1)
            )
            .padding(.horizontal, 20)
        }
        .navigationDestination(isPresented: $isChatPresented) {
            ChatCategoryView(vm: vm, title: title)
        }
    }
    
    private func sendCategory() {
        Task {
            await vm.send(text: text_send)
            isActive = true
        }
    }
}

