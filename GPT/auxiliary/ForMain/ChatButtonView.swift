//
//  ChatButtonView.swift
//  GPT
//
//  Created by Alibek Shakirov on 02.05.2024.
//

import SwiftUI

struct ChatButtonView: View {
    @StateObject var viewModel: ChatViewModel
    
    var body: some View {
        NavigationLink(destination: ChatView(vm: viewModel)) {
            Image(systemName: "message")
                .foregroundColor(.black)
                .font(.title)
        }
    }
}

#Preview {
    ChatButtonView(viewModel:  ChatViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY")))
}
