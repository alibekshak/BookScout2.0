import Foundation
import SwiftUI

class ChatSameBookViewModel: ObservableObject {
    @Published var isInteractingWithChatGPT = false
    @Published var messages: [MessageRow] = []
    @Published var inputMessage: String = ""
    @Published var isSending = false
    @Published var favoritesViewModel = FavoritesViewModel()
    @Published var isGeneratingText = false
    
    private let userDefaults = UserDefaults.standard
    private let api: ChatGPTAPI
    private let book: String
    private let author: String
    
    init(api: ChatGPTAPI, book: String, author: String , enableSpeech: Bool = false) {
        self.api = api
        self.book = book
        self.author = author
        
        let decoder = JSONDecoder()
        if let data = userDefaults.data(forKey: "FavoriteItems"),
           let decodedData = try? decoder.decode([FavoriteItem].self, from: data) {
            favoritesViewModel.favoriteItems = decodedData
        }
    }
    
    @MainActor
    func sendTapped() async {
        let text = ""
        inputMessage = ""
        await send(text: text)
    }
    
    @MainActor
    func clearMessages() {
        api.deleteHistoryList()
        withAnimation { [weak self] in
            self?.messages = []
        }
    }
    
    @MainActor
    func retry(message: MessageRow) async {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else {
            return
        }
        self.messages.remove(at: index)
        await send(text: message.sendText)
    }
            
    @MainActor
    internal func send(text: String) async {
        isInteractingWithChatGPT = true
        isGeneratingText = true
        var streamText = ""
        var messageRow = MessageRow(
            isInteractingWithChatGPT: true,
            sendImage: "profile",
            sendText: text,
            responseImage: "openai",
            responseText: streamText,
            responseError: nil)
        
        self.messages.append(messageRow)
        
        do {
            let stream = try await api.sendMessageStream(text: text)
            for try await text in stream {
                streamText += text
                messageRow.responseText = streamText.trimmingCharacters(in: .whitespacesAndNewlines)
                self.messages[self.messages.count - 1] = messageRow
            }
        } catch {
            messageRow.responseError = error.localizedDescription
        }
        
        messageRow.isInteractingWithChatGPT = false
        self.messages[self.messages.count - 1] = messageRow
        isInteractingWithChatGPT = false
        isGeneratingText = false
    }
    
    func addToFavorites(text: String) {
        let favoriteItem = FavoriteItem(title: text)
        favoritesViewModel.addToFavorites(item: favoriteItem)

        // Save the updated favoriteItems array to UserDefaults
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(favoritesViewModel.favoriteItems) {
            UserDefaults.standard.set(encodedData, forKey: "FavoriteItems")
        }
    }
}

struct ChatSameBookView: View {
    @ObservedObject var vm: ChatSameBookViewModel
    @FocusState var isTextFieldFocused: Bool
    @State private var showingSheet = false
    @Environment(\.presentationMode) var presentationMode
    @State private var shouldPopToRoot = false
    @State private var addToFavoritesTapped = false
    @State private var isFavoritesListPresented = false
    
    var body: some View {
        VStack{Text("")}
            chatListView
                .navigationTitle("Похожии стиль")
                .navigationBarItems(leading: vm.isGeneratingText ? nil : Chevron().imageScale(.medium))
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
        VStack{
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
                    HStack(alignment: .top, spacing: 120) {
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
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

struct ChatSameBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatSameBookView(vm: ChatSameBookViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY"), book: "BOOK", author: "AUTHOR"))
        }
    }
}
