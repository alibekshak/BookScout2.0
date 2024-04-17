//
//  FavoriteItem.swift
//  GPT
//
//  Created by Alibek Shakirov on 17.04.2024.
//

import Foundation

struct FavoriteItem: Identifiable, Hashable, Codable {
    var id = UUID()
    let title: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FavoriteItem, rhs: FavoriteItem) -> Bool {
        return lhs.id == rhs.id
    }
}
