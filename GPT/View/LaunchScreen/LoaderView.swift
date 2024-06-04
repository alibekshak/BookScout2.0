//
//  LoaderView.swift
//  GPT
//
//  Created by Alibek Shakirov on 04.06.2024.
//

import SwiftUI

struct LoaderView: View {
    @State private var degree = 270
    var count: Int = 12
    
    var body: some View {
        GeometryReader { bounds in
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(CustomColors.strokeColor)
                    .frame(
                        width: getDotSize(index),
                        height: getDotSize(index),
                        alignment: .center
                    )
                    .offset(x: (bounds.size.width / 2) - 10)
                    .rotationEffect(.degrees(.pi * 2 * Double(index * 5)))
            }
            .frame(
                width: bounds.size.width,
                height: bounds.size.height,
                alignment: .center
            )
            .rotationEffect(.degrees(Double(degree)))
            .animation(
                Animation.linear(duration: 1.7)
                    .repeatForever(autoreverses: false),
                value: degree
            )
            .onAppear {
                degree = 270 + 360
            }
        }
        .frame(width: 70, height: 70)
    }
    
    private func getDotSize(_ index: Int) -> CGFloat {
        CGFloat(index)
    }
}

#Preview {
    LoaderView()
}
