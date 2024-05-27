import Foundation
import SwiftUI

struct ChatCategoryView: View {
    
    @StateObject var vm: ChatCategoryViewModel
    
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
            vm.loadFavorites()
        }
    }
    
    var navigationBar: some View {
        HStack {
            Chevron(isDisabled: vm.isInteractingWithChatGPT)
            Spacer()
            Text("Категория")
                .foregroundColor(.black)
                .font(.system(size: 26, weight: .semibold))
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 22)
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: .zero) {
                ScrollView {
                    LazyVStack(spacing: 4) {
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
                bottomView(image: "profile", proxy: proxy)
            }
            .onChange(of: vm.messages.last?.responseText) { _ in scrollToBottom(proxy: proxy) }
        }
    }
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        VStack {
            if !vm.isInteractingWithChatGPT {
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
                await vm.sendTapped()
            }
        }) {
            Text("Предложить еще книгу")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(DarkButtonStyle())
        .padding(.horizontal, 30)
    }
    
    var tabView: some View {
        VStack(spacing: .zero) {
            Divider()
            HStack(alignment: .center, spacing: 120) {
                buttonSheet
                if let generatedText = vm.messages.last?.responseText {
                    bookmark(generatedText: generatedText)
                }
            }
            .padding(.top, 8)
            .disabled(vm.isInteractingWithChatGPT)
        }
    }
    
    func bookmark(generatedText: String) -> some View {
        Button(action: {
            addToFavoritesTapped.toggle()
            vm.addToFavorites(text: generatedText)
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
            ActionSheet(title: Text("Рекомендация"),
                        message: Text("Иногда искусственный интеллект неправильно переводит книги на русский язык, поэтому рекомендуется использовать англоязычное название книги"),
                        buttons: [.default(Text("Ок"))])
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        withAnimation {
            proxy.scrollTo(id, anchor: .bottom)
        }
    }
}

struct ChatCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatCategoryView(vm: ChatCategoryViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY"), category: "CATEGORY_VALUE"))
        }
    }
}
