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
                CustomColors.customBlack
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
                VStack(spacing: 12) {
                    Image(systemName: "books.vertical.circle")
                        .font(.system(
                            size: 42,
                            weight: .semibold,
                            design: .rounded)
                        )
                    Text("Изменения добавлены")
                        .font(.system(
                            size: 22,
                            weight: .semibold,
                            design: .serif)
                        )
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 230)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .cornerRadius(14, corners: [.topLeft, .topRight])
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)

    }
}

#Preview {
    NotificationSheetView(isShowing: .constant(true))
}
