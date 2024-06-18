import SwiftUI

struct SelectAuthorFiction: View {
    
    @State private var author = ""
    
    @FocusState var isWordFieldFocused: Bool
    
    @StateObject var chatBookViewModel: ChatBookViewModel
    
    var body: some View {
        ZStack {
            CustomColors.backgroundColor
                .ignoresSafeArea()
            VStack {
                navigationBar
                VStack(spacing: 60) {
                    WordField(word: $author, placeholder: "Харуки Мураками", isFocused: _isWordFieldFocused)
                    textWarning
                }
                Spacer()
                ButtonFind(chatBookViewModel: chatBookViewModel, sendType: .selectAutor, selectedAuthor: author)
                    .padding(.bottom)
            }
            .padding(.horizontal, 20)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            isWordFieldFocused = true
        }
    }
    
    var navigationBar: some View {
        HStack {
            Chevron()
            Spacer()
            Text("Имя автора")
                .foregroundColor(Color.black)
                .font(.system(size: 24, weight: .semibold))
            Spacer()
        }
        .padding(.bottom, 30)
    }
    
    var textWarning: some View {
        Text("Иногда искусственный интеллект неправильно переводит книги на русский язык, поэтому рекомендуется использовать англоязычное название книги")
            .foregroundColor(Color.black.opacity(0.6))
            .font(.system(size: 18))
    }
}

struct SelectAuthorFiction_Previews: PreviewProvider {
    static var previews: some View {
        SelectAuthorFiction(chatBookViewModel: ChatBookViewModel(api: ChatGPTAPI(apiKey: "")))
    }
}

