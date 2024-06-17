//
//  APIManager.swift
//  GPT
//
//  Created by Alibek Shakirov on 17.06.2024.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    let api: ChatGPTAPI

    private init() {
        self.api = ChatGPTAPI(apiKey: "PROVIDE_API_KEY")
    }
}
