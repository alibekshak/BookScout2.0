import Foundation
import SwiftUI

struct ChatCategoryView: View {
    
    @StateObject var chatCategoryViewModel: ChatCategoryViewModel
    
    @FocusState var isTextFieldFocused: Bool
    
    @State private var showingSheet = false
    @State private var addToFavoritesTapped = false
    
    var title: String
    
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
            chatCategoryViewModel.loadFavorites()
        }
    }
    
    var navigationBar: some View {
        HStack {
            Chevron(isDisabled: chatCategoryViewModel.isInteractingWithChatGPT)
            Spacer()
            Text(title)
                .foregroundColor(.black)
                .font(.system(size: 26, weight: .semibold))
                .padding(.trailing)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 22)
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: .zero) {
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(chatCategoryViewModel.messages) { message in
                            MessageRowView(message: message) { message in
                                Task { @MainActor in
                                    await chatCategoryViewModel.retry(message: message)
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        isTextFieldFocused = false
                    }
                }
                bottomView(proxy: proxy)
            }
            .onChange(of: chatCategoryViewModel.messages.last?.responseText) { _ in scrollToBottom(proxy: proxy) }
        }
    }
    
    func bottomView(proxy: ScrollViewProxy) -> some View {
        VStack {
            if !chatCategoryViewModel.isInteractingWithChatGPT {
                suggestButton(proxy: proxy)
            }
            tabView
        }
    }
    
    func suggestButton(proxy: ScrollViewProxy) -> some View {
        Button(action: {
            Task {
                isTextFieldFocused = false
                scrollToBottom(proxy: proxy)
                await chatCategoryViewModel.sendTapped()
            }
        }) {
            Text("Предложить еще книгу")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(DarkButtonStyle())
        .padding(.horizontal, 20)
    }
    
    var tabView: some View {
        VStack(spacing: .zero) {
            Divider()
            HStack(alignment: .center, spacing: 120) {
                buttonSheet
                if let generatedText = chatCategoryViewModel.messages.last?.responseText {
                    bookmark(generatedText: generatedText)
                }
            }
            .padding(.top, 8)
            .disabled(chatCategoryViewModel.isInteractingWithChatGPT)
        }
    }
    
    func bookmark(generatedText: String) -> some View {
        Button(action: {
            addToFavoritesTapped.toggle()
            chatCategoryViewModel.addToFavorites(text: generatedText)
        }) {
            Image(systemName: "bookmark.fill")
                .foregroundColor(CustomColors.backgroundColor)
                .frame(width: 30, height: 30)
                .background(Color.black)
                .cornerRadius(20)
        }
        .alert(isPresented: $addToFavoritesTapped) {
            Alert(title: Text("Избранное"), message: Text("Текст добавлен в избранное"), dismissButton: .default(Text("Ок")))
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
            ActionSheet(title: Text("Пожалуйста, обратите внимание"),
                        message: Text("Искусственного интеллекта может допускать ошибки в распознавании и упоминании названий книг или имен авторов"),
                        buttons: [.default(Text("Ок"))])
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = chatCategoryViewModel.messages.last?.id else { return }
        withAnimation {
            proxy.scrollTo(id, anchor: .bottom)
        }
    }
}

struct ChatCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatCategoryView(chatCategoryViewModel: ChatCategoryViewModel(api: APIManager.shared.api, category: "CATEGORY_VALUE"), title: "Роман")
        }
    }
}
