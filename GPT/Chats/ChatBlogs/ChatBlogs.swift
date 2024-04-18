import Foundation
import SwiftUI

struct ChatBlogsView: View {
    
    @StateObject var vm: ChatBlogsViewModel
    @FocusState var isTextFieldFocused: Bool
    @State private var showingSheet = false
    @State private var isLoading = false
    
    var body: some View {
        VStack{Text("")}
        chatListView
            .navigationTitle("Blog")
            .navigationBarItems(leading: vm.isGeneratingText ? nil : Chevron().imageScale(.small))
            .navigationBarBackButtonHidden(true)
    }
    
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.messages) { message in
                            MessageRowView(message: message) { message in
                                Task { @MainActor in
                                    await vm.retry(message: message)
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        isTextFieldFocused = false
                    }
                }
                Divider()
                bottomView(image: "profile", proxy: proxy)
                Spacer()
                
                
            }
            .onChange(of: vm.messages.last?.responseText) { _ in scrollToBottom(proxy: proxy) }
        }
        .background(Color(red: 240/255, green: 240/255, blue: 240/255))
    }
    
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        
        return VStack{
            HStack{
                Rectangle()
                    .fill(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.7))
                    .frame(height: 1) // Высота линии
                    .padding(.top, -1) // Отступ сверху, чтобы линия отображалась выше остальных элементов
                    .padding(.horizontal, -95) // Отступы по горизонтали, чтобы линия была шире
            }
            Group {
                if vm.isGeneratingText {
                    DotLoadingView().frame(width: 100, height: 50)
                }else{
                    HStack(alignment: .top, spacing: 110) {
                        Button(action: {
                            self.showingSheet = true
                        }){
                            Image(systemName: "exclamationmark.octagon")
                                .foregroundColor(Color.black)
                                .font(.title)
                        }.actionSheet(isPresented: $showingSheet){
                            ActionSheet(title: Text("Рекомендация"),
                                        message: Text("Иногда искусственный интеллект неправильно переводит книги на русский язык, поэтому рекомендуется использовать англоязычное название книги"),
                                        buttons: [.default(Text("Ок"))])
                        }
                        
                        ButtonHouse()
                        
                    }
                }
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

struct ChatBlogsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatBlogsView(vm: ChatBlogsViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY")))
        }
    }
}

