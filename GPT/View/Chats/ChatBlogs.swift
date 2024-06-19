import Foundation
import SwiftUI

struct ChatBlogsView: View {
    
    @StateObject var chatBlogsViewModel: ChatBlogsViewModel
    @State private var showingSheet = false
    
    var body: some View {
        ZStack {
            CustomColors.backgroundColor
                .ignoresSafeArea()
            VStack(spacing: .zero) {
                navigationBar
                Divider()
                chatListView
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var navigationBar: some View {
        HStack {
            Chevron(isDisabled: chatBlogsViewModel.isInteractingWithChatGPT)
            Spacer()
            Text("Blog")
                .foregroundColor(.black)
                .font(.system(size: 26, weight: .semibold))
            Spacer()
            buttonSheet
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 22)
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: .zero) {
                message
            }
            .onChange(of: chatBlogsViewModel.messages.last?.responseText) { _ in
                scrollToBottom(proxy: proxy)
            }
        }
    }
    
    var message: some View {
        ScrollView {
            LazyVStack(spacing: .zero) {
                ForEach(chatBlogsViewModel.messages) { message in
                    MessageRowView(message: message) { message in
                        Task { @MainActor in
                            await chatBlogsViewModel.retry(message: message)
                        }
                    }
                }
            }
        }
    }
    
    var buttonSheet: some View {
        Button {
            withAnimation {
                self.showingSheet = true
            }
        } label: {
            Image(systemName: "exclamationmark.octagon")
                .foregroundColor(Color.black)
                .font(
                    .system(
                        size: 26,
                        weight: .semibold,
                        design: .rounded
                    )
                )
        }
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text("Рекомендация"),
                        message: Text("Иногда искусственный интеллект неправильно переводит книги на русский язык, поэтому рекомендуется использовать англоязычное название книги"),
                        buttons: [.default(Text("Ок"))])
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = chatBlogsViewModel.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

struct ChatBlogsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatBlogsView(chatBlogsViewModel: ChatBlogsViewModel(api: APIManager.shared.api))
        }
    }
}

