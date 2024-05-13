//
//  DarkButtonStyle.swift
//  GPT
//
//  Created by Alibek Shakirov on 13.05.2024.
//

import SwiftUI

struct DarkButtonStyle: ButtonStyle {
    private let feedbackGenerator: UIImpactFeedbackGenerator
    private let backgroundColor: Color
    private let textColor: Color
    private let padding: CGFloat
    private let cornerRadius: CGFloat

    public init(
        feedbackGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium),
        backgroundColor: Color = Color.black,
        textColor: Color = Color.white,
        padding: CGFloat = 18,
        cornerRadius: CGFloat = 40
    ) {
        self.feedbackGenerator = feedbackGenerator
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.padding = padding
        self.cornerRadius = cornerRadius
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .padding(padding)
            .background(backgroundColor)
            .foregroundStyle(textColor)
            .cornerRadius(cornerRadius)
            .opacity(configuration.isPressed ? 0.4 : 1)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.interactiveSpring(blendDuration: 0.4), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    feedbackGenerator.impactOccurred()
                }
            }
    }
}
