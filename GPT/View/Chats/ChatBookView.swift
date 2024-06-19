import Foundation
import SwiftUI

struct ChatBookView: View {
    
    @StateObject var chatBookViewModel: ChatBookViewModel
    
    @FocusState var isTextFieldFocused: Bool
    
    @State private var showingSheet = false
    @State private var addToFavoritesTapped = false
    
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
        .onAppear {
            chatBookViewModel.loadFavorites()
        }
    }
    
    var navigationBar: some View {
        HStack {
            Chevron(isDisabled: chatBookViewModel.isInteractingWithChatGPT)
            Spacer()
            Text("Книги")
                .foregroundColor(.black)
                .font(.system(size: 26, weight: .semibold))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 22)
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(chatBookViewModel.messages) { message in
                        MessageRowView(message: message) { message in
                            Task { @MainActor in
                                await chatBookViewModel.retry(message: message)
                            }
                        }
                    }
                }
                .onTapGesture {
                    isTextFieldFocused = false
                }
            }
            bottomView(proxy: proxy)
                .onChange(of: chatBookViewModel.messages.last?.responseText) { _ in scrollToBottom(proxy: proxy)
                }
        }
        
    }
    
    func bottomView(proxy: ScrollViewProxy) -> some View {
        VStack(spacing: .zero) {
            if !chatBookViewModel.isInteractingWithChatGPT {
                Divider()
                HStack(alignment: .center, spacing: 120) {
                    buttonSheet
                    if let generatedText = chatBookViewModel.messages.last?.responseText {
                        bookmark(generatedText: generatedText)
                    }
                }
                .padding(.top, 8)
            }
        }
    }
    
    func bookmark(generatedText: String) -> some View {
        Button(action: {
            addToFavoritesTapped.toggle()
            chatBookViewModel.addToFavorites(text: generatedText)
        }) {
            Image(systemName: "bookmark.fill")
                .foregroundColor(.black)
                .font(.title)
        }
        .alert(isPresented: $addToFavoritesTapped) {
            Alert(title: Text("Избранное"), message: Text("Текст добавлен в избранное"), dismissButton: .default(Text("Ок")))
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
                .font(.title)
        }
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text("Рекомендация"),
                        message: Text("Иногда искусственный интеллект неправильно переводит книги на русский язык, поэтому рекомендуется использовать англоязычное название книги"),
                        buttons: [.default(Text("Ок"))])
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = chatBookViewModel.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

struct ChatBookView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBookView(chatBookViewModel: ChatBookViewModel(api: APIManager.shared.api))
    }
}
