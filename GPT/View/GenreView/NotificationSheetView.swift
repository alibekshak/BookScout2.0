//
//  NotificationSheetView.swift
//  GPT
//
//  Created by Alibek Shakirov on 13.06.2024.
//

import SwiftUI

struct NotificationSheetView: View {
    
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                CustomColors.backgroundColor
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
                VStack(spacing: 12) {
                    Image(systemName: "books.vertical.circle")
                        .font(.system(
                            size: 32,
                            weight: .semibold,
                            design: .rounded)
                        )
                    Text("Жанр успешно добавлен")
                        .font(.system(
                            size: 22,
                            weight: .semibold,
                            design: .serif)
                        )
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 250)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

#Preview {
    NotificationSheetView(isShowing: .constant(true))
}
