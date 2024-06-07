//
//  Category.swift
//  GPT
//
//  Created by Alibek Shakirov on 07.06.2024.
//

import Foundation

struct Category: Identifiable {
    let id = UUID()
    let title: String
    let text: String
    let textSend: String
}
