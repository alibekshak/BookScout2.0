import SwiftUI

struct SelectAuthorFiction: View {
    
    @State private var isActive: Bool = false
    @State private var author = ""
    @State private var book = ""
    
    @StateObject var vm: ChatBookViewModel
    
    var body: some View {
        ZStack {
            CustomColors.backgroundColor
                .ignoresSafeArea()
            VStack {
                navigationBar
                VStack(spacing: 60) {
                    wordField
                    textWarning
                }
                Spacer()
                ButtonFind(vm: vm, isActive: $isActive, sendType: .selectAutor, selectedAuthor: author)
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
            Text("Имя автора")
                .foregroundColor(Color.black)
                .font(.system(size: 24, weight: .semibold))
            Spacer()
        }
        .padding(.bottom, 30)
    }
    
    var wordField: some View {
        VStack {
            WordField(word: $author, placeholder: "Харуки Мураками")
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

struct SelectAuthorFiction_Previews: PreviewProvider {
    static var previews: some View {
        SelectAuthorFiction(vm: ChatBookViewModel(api: ChatGPTAPI(apiKey: "")))
    }
}

