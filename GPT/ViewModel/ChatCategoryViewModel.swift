//
//  ChatCategoryViewModel.swift
//  GPT
//
//  Created by Alibek Shakirov on 15.04.2024.
//

import Foundation
import SwiftUI

class ChatCategoryViewModel: BaseChatViewModel {
    private let category: String

    init(api: ChatGPTAPI, category: String) {
        self.category = category
        super.init(api: api)
    }

    @MainActor
    func sendTapped() async {
        let text = "Рекомендуй книгу в жанре \(category) ?"
        isInteractingWithChatGPT = true
        await send(text: text)
        isInteractingWithChatGPT = false
    }

    @MainActor
    func retry(message: MessageRow) async {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else {
            return
        }
        isInteractingWithChatGPT = true
        self.messages.remove(at: index)
        await send(text: message.sendText)
        isInteractingWithChatGPT = false
    }
}
