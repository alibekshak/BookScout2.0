//
//  TabViewMain.swift
//  GPT
//
//  Created by Alibek Shakirov on 15.05.2024.
//

import SwiftUI

struct TabViewMain: View {
    
    @StateObject var appState: GenreSelectionViewModel
    @StateObject var chatViewModel = ChatViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY"))
    
    
    @State var selectedTab: Tab = .main
    
    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                switch selectedTab {
                case .main:
                    MainPage()
                case .chat:
                    ChatView(vm: chatViewModel)
                case .genre:
                    GenreSelectionView(viewModel: appState, states: .genreTab)
                }
                CustomView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    TabViewMain(appState: GenreSelectionViewModel())
}
