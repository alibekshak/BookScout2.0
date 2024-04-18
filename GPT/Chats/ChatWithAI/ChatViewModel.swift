import Foundation
import SwiftUI
import AVKit

class ChatViewModel: ObservableObject {
    
    @Published var isInteractingWithChatGPT = false
    @Published var messages: [MessageRow] = []
    @Published var inputMessage: String = ""
    
    private var synthesizer: AVSpeechSynthesizer?
    
    private let api: ChatGPTAPI
    
    init(api: ChatGPTAPI, enableSpeech: Bool = false) {
        self.api = api
        if enableSpeech {
            synthesizer = .init()
        }
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
    
    
    @MainActor
    func sendTapped() async {
        let text = inputMessage
        inputMessage = ""
        await send(text: text)
    }
    
    @MainActor
    func clearMessages() {
        stopSpeaking()
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
    private func send(text: String) async {
        isInteractingWithChatGPT = true
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
        speakLastResponse()
        
    }
    
    func speakLastResponse() {
        guard let synthesizer, let responseText = self.messages.last?.responseText, !responseText.isEmpty else {
            return
        }
        stopSpeaking()
        let utterance = AVSpeechUtterance(string: responseText)
        utterance.voice = .init(language: "en-US")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        synthesizer.speak(utterance )
    }
    
    func stopSpeaking() {
        synthesizer?.stopSpeaking(at: .immediate)
    }
    
    @MainActor func refreshChat() {
        clearMessages()
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
