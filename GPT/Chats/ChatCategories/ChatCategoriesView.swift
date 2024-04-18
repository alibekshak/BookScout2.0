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
                                .foregroundColor(Color(red: 30/255, green: 30/255, blue: 30/255))
                            
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
            
            
            VStack{
                HStack{
                    Rectangle()
                        .fill(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.7))
                        .frame(height: 1) // Высота линии
                        .padding(.top, -1) // Отступ сверху, чтобы линия отображалась выше остальных элементов
                        .padding(.horizontal, -95) // Отступы по горизонтали, чтобы линия была шире
                }
                
                HStack(alignment: .top, spacing: 120) {
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
                    .offset(y: -2)
                    if let generatedText = vm.messages.last?.responseText {
                        Button(action: {
                            addToFavoritesTapped.toggle()
                            vm.addToFavorites(text: generatedText)
                        }) {
                            Image(systemName: "bookmark.fill")
                                .foregroundColor(Color(red: 240/255, green: 240/255, blue: 240/255))
                                .frame(width: 30, height: 30)
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                        .alert(isPresented: $addToFavoritesTapped) {
                            Alert(title: Text("Избранное"), message: Text("Текст добавлен в избранное"), dismissButton: .default(Text("Ок")))
                        }
                    }
                    
                }
                .offset(y: 5)
            }
            
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
