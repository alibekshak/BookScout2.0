//
//  CustomView.swift
//  GPT
//
//  Created by Alibek Shakirov on 15.05.2024.
//

import SwiftUI

struct CustomView: View {
    
    @Binding var selectedTab: Tab
    
    var body: some View {
        VStack(spacing: .zero) {
            Divider()
            HStack {
                ForEach(Tab.allCases) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        Image(systemName: tab.image)
                            .frame(maxWidth: .infinity)
                            .font(
                                .system(
                                    size: 26,
                                    weight: .bold,
                                    design: .serif
                                )
                            )
                            .foregroundColor(
                                selectedTab == tab ?
                                    .black : .black.opacity(0.4)
                            )
                            .scaleEffect(selectedTab == tab ? 1 : 0.92)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        .background(CustomColors.backgroundColor)
    }
}

#Preview {
    CustomView(selectedTab: .constant(.chat))
}
