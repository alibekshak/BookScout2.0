import Foundation
import SwiftUI

struct ChatBlogsView: View {
    
    @StateObject var vm: ChatBlogsViewModel
    @FocusState var isTextFieldFocused: Bool
    @State private var showingSheet = false
    
    var body: some View {
        ZStack {
            CustomColors.backgroundColor
                .ignoresSafeArea()
            VStack(spacing: .zero) {
                navigationBar
                chatListView
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var navigationBar: some View {
        HStack {
            Chevron()
            Spacer()
            Text("Blog")
                .foregroundColor(.black)
                .font(.system(size: 26, weight: .semibold))
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 32)
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: .zero) {
                message
                bottomView(image: "profile", proxy: proxy)
            }
            .onChange(of: vm.messages.last?.responseText) { _ in
                scrollToBottom(proxy: proxy)
            }
        }
    }
    
    var message: some View {
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
    }
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        VStack {
            Divider()
            HStack(alignment: .center, spacing: 110) {
                buttonSheet
                ButtonHouse()
            }
            .padding(.top)
            .disabled( vm.isInteractingWithChatGPT)
        }
    }
    
    var buttonSheet: some View {
        Button(action: {
            self.showingSheet = true
        }) {
            Image(systemName: "exclamationmark.octagon")
                .foregroundColor(Color.black)
                .font(.title)
        }
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text("Рекомендация"),
                        message: Text("Иногда искусственный интеллект неправильно переводит книги на русский язык, поэтому рекомендуется использовать англоязычное название книги"),
                        buttons: [.default(Text("Ок"))])
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

