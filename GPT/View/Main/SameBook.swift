import SwiftUI

struct SameBookFiction: View {
    
    @State private var author = ""
    @State private var book = ""
    @State private var isActive: Bool = false
    
    @StateObject var vm: ChatBookViewModel
    
    var body: some View {
        ZStack {
            CustomColors.backgroundColor
                .ignoresSafeArea()
            VStack {
                navigationBar
                VStack(spacing: 60) {
                    textFields
                    textWarning
                }
                Spacer()
                ButtonFind(vm: vm, isActive: $isActive, sendType: .sameBook, selectedAuthor: author, selectedBook: book)
                    .padding(.bottom)
            }
            .padding(.horizontal, 28)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var navigationBar: some View {
        HStack {
            Chevron()
            Spacer()
            Text("Введите данные:")
                .foregroundColor(Color.black)
                .font(.system(size: 24, weight: .semibold))
            Spacer()
        }
        .padding(.bottom, 30)
    }
    
    var textFields: some View {
        VStack(spacing: 30) {
            WordField(word: $author, placeholder: "Харуки Мураками")
            WordField(word: $book, placeholder: "Норвежский лес")
        }
    }
    
    var textWarning: some View {
        VStack {
            Text("Иногда искусственный интеллект неправильно переводит книги на русский язык, поэтому рекомендуется использовать англоязычное название книги")
                .foregroundColor(Color.black.opacity(0.6))
                .font(.system(size: 18))
                .multilineTextAlignment(.leading)
        }
    }
}

struct SameBookFiction_Previews: PreviewProvider {
    static var previews: some View {
        SameBookFiction(vm: ChatBookViewModel(api: ChatGPTAPI(apiKey: "CATEGORY_VALUE")))
    }
}

