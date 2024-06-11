import Foundation
import SwiftUI

class ChatViewModel: BaseChatViewModel {
    
    @Published var inputMessage: String = ""
    
    init(api: ChatGPTAPI, enableSpeech: Bool = false) {
        super.init(api: api)
        DispatchQueue.main.async {
            self.appearChat()
        }
    }
    
    @MainActor
    func sendTapped() async {
        let text = inputMessage
        inputMessage = ""
        await send(text: text)
    }
    
    @MainActor
    func clearMessages() {
        api.deleteHistoryList()
        withAnimation { [weak self] in
            self?.messages.removeAll()
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
    
    @MainActor func refreshChat() {
        clearMessages()
        DispatchQueue.main.async {
            self.appearChat()
        }
    }
    
    @MainActor func appearChat() {
        Task {
            if let selectedGenresData = UserDefaults.standard.data(forKey: "selectedGenres") {
                if let selectedGenres = try? JSONDecoder().decode(Set<BookGenre>.self, from: selectedGenresData) {
                    let genresString = selectedGenres.map { $0.rawValue }.joined(separator: ", ")
                    let initialMessage = "Жанры которые мне нравятся \(genresString), дублируй мне названия этих жанров и кратко опеши мне их, потом напиши - 'Какую книгу или автора вы хотите обсудить?'"
                    await send(text: initialMessage)
                }
            }
        }
    }
}
