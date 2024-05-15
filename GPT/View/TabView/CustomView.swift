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
        HStack(spacing: 68) {
            ForEach(Tab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    Image(systemName: tab.image)
                        .font(.system(size: 22, weight: .semibold))
                }
            }
        }
    }
}

#Preview {
    CustomView(selectedTab: .constant(.chat))
}
