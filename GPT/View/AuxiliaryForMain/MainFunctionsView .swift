//
//  MainFunctionsView .swift
//  GPT
//
//  Created by Alibek Shakirov on 08.07.2024.
//

import SwiftUI

struct MainFunctionsView: View {
    
    var image: String
    var text: String
    
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            Image(image)
                .resizable()
            Text(text)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
                .padding()
        }
        .frame(width: 340, height: 240)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(CustomColors.strokeColor, lineWidth: 1)
        )
    }
}

#Preview {
    MainFunctionsView(image: "authors", text: "Hello")
}
