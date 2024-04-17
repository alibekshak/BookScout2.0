//
//  ChatCategoryViewModel.swift
//  GPT
//
//  Created by Alibek Shakirov on 15.04.2024.
//

import Foundation
import SwiftUI

class ChatCategoryViewModel: ObservableObject {
    
    @Published var isInteractingWithChatGPT = false
    @Published var messages: [MessageRow] = []
    @Published var inputMessage: String = ""
    @Published var isSending = false
    @Published var favoritesViewModel = FavoritesViewModel()
    @Published var isGeneratingText = false
    
    private let userDefaults = UserDefaults.standard
    private let api: ChatGPTAPI
    private let category: String
    
    init(api: ChatGPTAPI, category: String, enableSpeech: Bool = false) {
        self.api = api
        self.category = category
        
        let decoder = JSONDecoder()
        if let data = userDefaults.data(forKey: "FavoriteItems"),
           let decodedData = try? decoder.decode([FavoriteItem].self, from: data) {
            favoritesViewModel.favoriteItems = decodedData
        }
    }
    
    @MainActor
    func sendTapped() async {
        let text = "Рекомендуй книгу в жанре \(category) ?"
        inputMessage = ""
        isSending = true
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
        isSending = false
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
