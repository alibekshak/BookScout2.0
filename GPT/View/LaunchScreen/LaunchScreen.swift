//
//  LaunchScreen.swift
//  GPT
//
//  Created by Alibek Shakirov on 14.05.2024.
//

import SwiftUI

struct LaunchScreen: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            CustomColors.backgroundColor
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("BookScout")
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundColor(Color.black)
                Image(systemName: "book.closed")
                    .font(
                        .system(
                            size: 100,
                            weight: .semibold,
                            design: .serif
                        )
                    )
                    .rotationEffect(.degrees(15), anchor: .center)
            }
            .scaleEffect(isAnimating ? 1.2 : 0.5)
            .animation(.easeInOut(duration: 1.3), value: isAnimating)
            ProgressView()
                .padding(.top, 300)
        }
        .onAppear {
            self.isAnimating = true
        }
    }
}

#Preview {
    LaunchScreen()
}
