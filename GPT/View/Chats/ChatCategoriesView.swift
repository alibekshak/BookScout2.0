import Foundation
import SwiftUI

struct ChatCategoryView: View {
    
    @StateObject var vm: ChatCategoryViewModel
    @FocusState var isTextFieldFocused: Bool
    @State private var showingSheet = false
    @State private var isLoading = false
    @Environment(\.presentationMode) var presentationMode
    @State private var shouldPopToRoot = false
    @State private var addToFavoritesTapped = false
    @State private var isFavoritesListPresented = false
    
    var body: some View {
        chatListView
            .navigationTitle("Категория")
            .navigationBarItems(leading: vm.isGeneratingText ? nil : Chevron().imageScale(.small))
            .navigationBarBackButtonHidden(true)
            .onAppear {
                // Load favorites from UserDefaults
                let decoder = JSONDecoder()
                if let data = UserDefaults.standard.data(forKey: "FavoriteItems"),
                   let decodedData = try? decoder.decode([FavoriteItem].self, from: data) {
                    vm.favoritesViewModel.favoriteItems = decodedData
                }
            }
    }
    
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: .zero) {
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
                bottomView(image: "profile", proxy: proxy)
            }
            .onChange(of: vm.messages.last?.responseText) { _ in scrollToBottom(proxy: proxy) }
        }
        .background(CustomColors.backgroundColor)
    }
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        VStack {
            if isLoading {
                DotLoadingView()
            } else {
                if !vm.isSending && !vm.isInteractingWithChatGPT {
                    Button(action: {
                        Task {
                            isTextFieldFocused = false
                            scrollToBottom(proxy: proxy)
                            await vm.sendTapped()
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 307, height: 44)
                                .foregroundColor(CustomColors.customBlack)
                            
                            Text("Предложить еще книгу")
                                .frame(width: 307, height: 44)
                                .foregroundColor(Color.white)
                                .font(.system(size: 22))
                        }
                        .padding(.top, 6)
                    }
                    .cornerRadius(10)
                }
            }
            VStack {
                Divider()
                HStack(alignment: .center, spacing: 120) {
                    buttonSheet
                    if let generatedText = vm.messages.last?.responseText {
                        bookmark(generatedText: generatedText)
                    }
                }
                .padding(.top)
            }
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
                .cornerRadius(10)
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