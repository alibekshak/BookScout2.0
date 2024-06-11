//
//  BaseChatViewModel.swift
//  GPT
//
//  Created by Alibek Shakirov on 11.06.2024.
//

import Foundation

class BaseChatViewModel: ObservableObject {
    @Published var isInteractingWithChatGPT = false
    @Published var messages: [MessageRow] = []
    @Published var favoritesViewModel = FavoritesViewModel.shared

    let userDefaults = UserDefaults.standard
    let api: ChatGPTAPI

    init(api: ChatGPTAPI) {
        self.api = api
        loadFavorites()
    }

    @MainActor
    func send(text: String) async {
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
    }

    func addToFavorites(text: String) {
        let favoriteItem = FavoriteItem(title: text)
        favoritesViewModel.addToFavorites(item: favoriteItem)

        // Save the updated favoriteItems array to UserDefaults
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(favoritesViewModel.favoriteItems) {
            userDefaults.set(encodedData, forKey: "FavoriteItems")
        }
    }

    func loadFavorites() {
        // Load favorites from UserDefaults
        let decoder = JSONDecoder()
        if let data = userDefaults.data(forKey: "FavoriteItems"),
           let decodedData = try? decoder.decode([FavoriteItem].self, from: data) {
            favoritesViewModel.favoriteItems = decodedData
        }
    }
}
