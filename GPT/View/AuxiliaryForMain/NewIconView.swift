//
//  NewIconView.swift
//  GPT
//
//  Created by Alibek Shakirov on 28.05.2024.
//

import SwiftUI

enum ViewState {
    case standard
    case alternative
}

struct NewIconView: View {
    
    var image: String
    var title: String
    var backgroundColor: Color
    
    @State var viewState: ViewState
    
    var body: some View {
        Group {
            if viewState == .standard {
                VStack(spacing: 14) {
                    Image(systemName: image)
                        .font(.system(size: 36,
                                      weight: .semibold,
                                      design: .rounded)
                        )
                    Text(title)
                        .font(.system(size: 16,
                                      weight: .semibold,
                                      design: .monospaced)
                        )
                        .multilineTextAlignment(.center)
                }
            } else {
                HStack(alignment: .center, spacing: 16) {
                    Image(systemName: image)
                        .font(.system(size: 36, weight: .semibold, design: .rounded))
                        .padding(.leading)
                    Text(title)
                        .font(.system(size: 18, weight: .semibold, design: .monospaced))
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 26)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(backgroundColor)
        .foregroundColor(.white)
        .cornerRadius(20)
    }
}

#Preview {
    NewIconView(image: "book.pages", title: "Художественная литература", backgroundColor: Color(red: 173/255, green: 216/255, blue: 230/255), viewState: .alternative)
}
