import SwiftUI


struct MessageRowView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let message: MessageRow
    let retryCallback: (MessageRow) -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            if let text = message.responseText {
                messageRowContent(text: text, bgColor:  CustomColors.backgroundColor, responseError: message.responseError, showDotLoading: message.isInteractingWithChatGPT)
            }
            Divider()
        }
    }
    
    func messageRowContent(text: String, bgColor: Color, responseError: String? = nil, showDotLoading: Bool = false) -> some View {
        VStack(alignment: .leading) {
            Text(text)
                .multilineTextAlignment(.leading)
                .textSelection(.enabled)
            if responseError != nil {
                Text("Мы не можем загрузить информацию прямо сейчас. Пожалуйста, попробуйте еще раз.")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.leading)
                Button("Попробовать еще раз") {
                    retryCallback(message)
                }
                .foregroundColor(.accentColor)
                .padding(.top)
            }
            if showDotLoading {
                DotLoadingView()
                    .frame(width: 60, height: 30)
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(bgColor)
    }
}


