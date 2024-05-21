import Foundation
import SwiftUI

struct ChatBookView: View {
    
    @StateObject var vm: ChatBookViewModel
    @FocusState var isTextFieldFocused: Bool
    @State private var showingSheet = false
    @Environment(\.presentationMode) var presentationMode
    @State private var shouldPopToRoot = false
    @State private var addToFavoritesTapped = false
    @State private var isFavoritesListPresented = false
    
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
            // Load favorites from UserDefaults
            let decoder = JSONDecoder()
            if let data = UserDefaults.standard.data(forKey: "FavoriteItems"),
               let decodedData = try? decoder.decode([FavoriteItem].self, from: data) {
                vm.favoritesViewModel.favoriteItems = decodedData
            }
        }
    }
    
    var navigationBar: some View {
        HStack {
            Chevron()
            Spacer()
            Text("Книги")
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
    }
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        VStack {
            Divider()
            Group {
                if vm.isGeneratingText {
                    DotLoadingView()
                        .frame(width: 100, height: 50)
                } else {
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
        }){
            Image(systemName: "exclamationmark.octagon")
                .foregroundColor(Color.black)
                .font(.title)
        }
        .actionSheet(isPresented: $showingSheet){
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

struct ChatBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatBookView(vm: ChatBookViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY")))
        }
    }
}
