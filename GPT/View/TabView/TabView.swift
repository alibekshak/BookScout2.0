//
//  TabView.swift
//  GPT
//
//  Created by Alibek Shakirov on 15.05.2024.
//

import SwiftUI

struct TabView: View {
    
    @StateObject private var appState = GenreSelectionViewModel()
    
    @State var selectedTab: Tab = .main
    
    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
//                switch selectedTab {
//                case .main:
//                    MainPages(appState: appState)
//                case .chat:
//                    <#code#>
//                case .genre:
//                    <#code#>
//                }
                CustomView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    TabView()
}
