//
//  ChevronView.swift
//  GPT
//
//  Created by Alibek Shakirov on 25.04.2024.
//

import SwiftUI

struct Chevron: View {
    @State private var showModal = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
            withAnimation {
                dismiss()
            }
        }) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    Chevron()
}
