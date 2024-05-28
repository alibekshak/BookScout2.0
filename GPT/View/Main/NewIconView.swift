//
//  NewIconView.swift
//  GPT
//
//  Created by Alibek Shakirov on 28.05.2024.
//

import SwiftUI

struct NewIconView: View {
    
    var image: String
    var title: String
    var backgroundColor: Color
    
    var body: some View {

            VStack(spacing: 14) {
                Image(systemName: image)
                    .font(.system(size: 36,
                                  weight: .semibold,
                                  design: .rounded)
                    )
                Text(title)
                    .font(.system(size: 16, 
                                  weight: .semibold,
                                  design: .monospaced))
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 20)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(20)
    }
}

#Preview {
    NewIconView(image: "book.pages", title: "Художественная литература", backgroundColor: Color(red: 173/255, green: 216/255, blue: 230/255))
}
