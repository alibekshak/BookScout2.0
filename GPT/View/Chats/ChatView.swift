import SwiftUI

struct ChatView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm: ChatViewModel
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        chatListView
            .navigationTitle("Чат AI")
            .navigationBarItems(
                leading: Chevron().imageScale(.small),
                trailing: refreshButton.imageScale(.small)
            )
            .navigationBarBackButtonHidden(true)
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: .zero) {
                messages
                bottomView(image: "profile", proxy: proxy)
            }
            .onChange(of: vm.messages.last?.responseText) { _ in
                scrollToBottom(proxy: proxy)
            }
        }
        .background(CustomColors.backgroundColor)
    }
    
    var messages: some View {
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
    }
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        HStack(alignment: .top, spacing: 8) {
            
            Image(image)
                .resizable()
                .frame(width: 30, height: 30)
                .cornerRadius(10)
            
            TextField("Send message", text: $vm.inputMessage, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .focused($isTextFieldFocused)
                .disabled(vm.isInteractingWithChatGPT)
            
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
                .disabled(vm.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isInteractingWithChatGPT)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
    
    var refreshButton: some View {
        Button(action: {
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