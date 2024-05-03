import SwiftUI


struct MessageRowView: View {

    @Environment(\.colorScheme) private var colorScheme
    
    let message: MessageRow
    let retryCallback: (MessageRow) -> Void
    
    var imageSize: CGSize {
        CGSize(width: 25, height: 25)
    }

    var body: some View {
        VStack(spacing: .zero) {
            if let text = message.responseText {
                Divider()
                messageRowContent(text: text, bgColor: colorScheme == .light ? .gray.opacity(0.1) : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 1), responseError: message.responseError, showDotLoading: message.isInteractingWithChatGPT)
                Divider()
            }
        }
    }

    @ViewBuilder
    func messageRowContent(text: String, bgColor: Color, responseError: String? = nil, showDotLoading: Bool = false) -> some View {
        VStack(alignment: .leading) {
            Text(text)
                .multilineTextAlignment(.leading)
                .textSelection(.enabled)
            if let error = responseError {
                Text("We cannot load info right now. Please try again.")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.leading)

                Button("Regenerate response") {
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
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(bgColor)
    }
}


