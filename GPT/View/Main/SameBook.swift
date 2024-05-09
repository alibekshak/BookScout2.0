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
                Spacer()
                VStack(spacing: 60) {
                    textFields
                    textWarning
                }
                Spacer()
                ButtonFind(vm: vm, isActive: $isActive, changeView: .sameBook, selectedAuthor: author, selectedBook: book)
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
                .font(.title)
            Spacer()
        }
        .padding(.bottom, 10)
    }
    
    var textFields: some View {
        VStack(spacing: 20) {
            WordField(word: $author, placeholder: "Харуки Мураками")
            WordField(word: $book, placeholder: "Норвежский лес")
        }
        .padding(.bottom)
    }
    
    var textWarning: some View {
        VStack {
            Text("Иногда искусственный интеллект неправильно переводит книги на русский язык, поэтому рекомендуется использовать англоязычное название книги")
                .foregroundColor(Color.black.opacity(0.6))
                .font(.custom("SanFrancisco", size: 17))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct SameBookFiction_Previews: PreviewProvider {
    static var previews: some View {
        SameBookFiction(vm: ChatBookViewModel(api: ChatGPTAPI(apiKey: "CATEGORY_VALUE")))
    }
}

