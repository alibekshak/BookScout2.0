import Foundation
import SwiftUI

class ChatBlogsViewModel: ObservableObject {
    @Published var isInteractingWithChatGPT = false
    @Published var messages: [MessageRow] = []
    @Published var inputMessage: String = ""
    @Published var isSending = false
    @Published var isGeneratingText = false
    
    private let api: ChatGPTAPI
    
    init(api: ChatGPTAPI, enableSpeech: Bool = false) {
        self.api = api
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
}

struct ChatBlogsView: View {
    @ObservedObject var vm: ChatBlogsViewModel
    @FocusState var isTextFieldFocused: Bool
    @State private var showingSheet = false
    @State private var isLoading = false
    
    var body: some View {
        VStack{Text("")}
        chatListView
            .navigationTitle("Blog")
            .navigationBarItems(leading: vm.isGeneratingText ? nil : Chevron().imageScale(.medium))
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

