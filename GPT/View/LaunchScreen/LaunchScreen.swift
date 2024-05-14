//
//  LaunchScreen.swift
//  GPT
//
//  Created by Alibek Shakirov on 14.05.2024.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            CustomColors.backgroundColor
                .ignoresSafeArea()
            VStack(spacing: 30) {
                Text("BookScout")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(Color.black)
                Image(systemName: "book.closed")
                    .font(
                        .system(
                            size: 100,
                            weight: .bold,
                            design: .serif
                        )
                    )
                    .rotationEffect(.degrees(15), anchor: .center)
                ProgressView()
                   
            }

        }
    }
}

#Preview {
    LaunchScreen()
}
