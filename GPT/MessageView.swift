import SwiftUI


struct MessageRowView: View {

    @Environment(\.colorScheme) private var colorScheme
    let message: MessageRow
    let retryCallback: (MessageRow) -> Void

    var imageSize: CGSize {
        CGSize(width: 25, height: 25)
    }

    var body: some View {
        VStack(spacing: 0) {
            if let text = message.responseText {
                Divider()
                messageRow(text: text, image: message.responseImage, bgColor: colorScheme == .light ? .gray.opacity(0.1) : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 1), responseError: message.responseError, showDotLoading: message.isInteractingWithChatGPT)
                Divider()
            }
        }
    }

    func messageRow(text: String, image: String, bgColor: Color, responseError: String? = nil, showDotLoading: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 24) {
            messageRowContent(text: text, image: image, responseError: responseError, showDotLoading: showDotLoading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(bgColor)
    }

    @ViewBuilder
    func messageRowContent(text: String, image: String, responseError: String? = nil, showDotLoading: Bool = false) -> some View {
        if image.hasPrefix("http"), let url = URL(string: image) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .frame(width: imageSize.width, height: imageSize.height)
            } placeholder: {
                ProgressView()
            }

        } else {
            Image(image)
                .resizable()
                .frame(width: imageSize.width, height: imageSize.height)
        }

        VStack(alignment: .leading) {
            Text(text)
                .multilineTextAlignment(.leading)
                .textSelection(.enabled)

            if let error = responseError {
                Text("Error: \(error)")
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
    }
}


