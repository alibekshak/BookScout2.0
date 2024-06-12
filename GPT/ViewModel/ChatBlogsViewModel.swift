//
//  ChatBlogsViewModel.swift
//  GPT
//
//  Created by Alibek Shakirov on 15.04.2024.
//

import Foundation
import SwiftUI

class ChatBlogsViewModel: BaseChatViewModel {
    
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
