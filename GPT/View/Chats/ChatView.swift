import SwiftUI

struct ChatView: View {
    
    @StateObject var vm: ChatViewModel
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            CustomColors.backgroundColor
                .ignoresSafeArea()
            VStack(spacing: .zero) {
                navigationBar
                Divider()
                chatListView
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            isTextFieldFocused = true
        }
    }
    
    var navigationBar: some View {
        HStack {
            Spacer()
            Text("Чат AI")
                .foregroundColor(.black)
                .font(.system(size: 26, weight: .semibold))
                .padding(.leading)
            Spacer()
            refreshButton
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 22)
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: .zero) {
                messages
                bottomView(proxy: proxy)
            }
            .onChange(of: vm.messages.last?.responseText) { _ in
                scrollToBottom(proxy: proxy)
            }
        }
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
    
    func bottomView(proxy: ScrollViewProxy) -> some View {
        HStack(alignment: .center) {
            textField
            buttonSend(proxy: proxy)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 4)
        .padding(.top, 12)
    }
    
    func buttonSend(proxy: ScrollViewProxy) -> some View {
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
        .foregroundColor(.accentColor)
        .disabled(vm.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isInteractingWithChatGPT)
    }
    
    var textField: some View {
        TextField("Отправить сообщение", text: $vm.inputMessage, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .focused($isTextFieldFocused)
            .disabled(vm.isInteractingWithChatGPT)
    }
    
    var refreshButton: some View {
        Button(action: {
            vm.refreshChat()
        }) {
            Image(systemName: "arrow.clockwise")  .foregroundColor(.black)
                .font(
                    .system(
                        size: 24,
                        weight: .semibold,
                        design: .serif
                    )
                )
                .opacity(vm.isInteractingWithChatGPT ? 0 : 1)
        }
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatView(vm: ChatViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY")))
        }
    }
}
