
import SwiftUI
import AVKit

struct ChatView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: ChatViewModel
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        VStack{Text("")}
        chatListView
            .navigationTitle("Чат AI")
            .navigationBarItems(leading: Chevron().imageScale(.medium),
                                trailing: refreshButton.imageScale(.medium))
            .navigationBarBackButtonHidden(true)
         
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.messages) { message in
                            MessageRowView(message: message) { message in
                                Task { @MainActor in
                                    await vm.retry(message: message)
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        isTextFieldFocused = false
                    }
                }

                Divider()
                bottomView(image: "profile", proxy: proxy)
                Spacer()

            }
            .onChange(of: vm.messages.last?.responseText) { _ in  scrollToBottom(proxy: proxy)
            }
        }
        .background(Color(red: 240/255, green: 240/255, blue: 240/255))
    }
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        HStack(alignment: .top, spacing: 8) {
            if image.hasPrefix("http"), let url = URL(string: image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 30, height: 30)
                } placeholder: {
                    ProgressView()
                }

            } else {
                Image(image)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            TextField("Send message", text: $vm.inputMessage, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .focused($isTextFieldFocused)
                .disabled(vm.isInteractingWithChatGPT)
            
            if vm.isInteractingWithChatGPT {
                DotLoadingView().frame(width: 60, height: 30)
            } else {
                Button {
                    Task { @MainActor in
                        isTextFieldFocused = false
                        scrollToBottom(proxy: proxy)
                        await vm.sendTapped()
                    }
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .rotationEffect(.degrees(45))
                        .font(.system(size: 30))
                }

                .buttonStyle(.borderless)
                .keyboardShortcut(.defaultAction)
                .foregroundColor(.accentColor)

                .disabled(vm.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }

    private var refreshButton: some View {
          Button(action: {
              // Call the refresh function in the view model
              vm.refreshChat()
          }) {
              Image(systemName: "arrow.clockwise")  .foregroundColor(.black)
                  .font(.title)
                  .opacity(vm.isInteractingWithChatGPT ? 0 : 1)
                  .disabled(vm.isInteractingWithChatGPT)
          }
      }
  }

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatView(vm: ChatViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY")))
        }
    }
}


struct ChatButtonView: View {
    @StateObject private var viewModel = ChatViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY")) // in this place nead to add API_KEY
    
    var body: some View {
        NavigationLink(destination: ChatView(vm: viewModel)) {
            Image(systemName: "message")
                .foregroundColor(.black)
                .font(.title)
        }
    }
}

