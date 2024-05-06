import SwiftUI

struct SelectAuthorFiction: View {
    
    @State private var isActive: Bool = false
    @State private var author = ""
    @State private var book = ""
    
    @StateObject var vm: ChatBookViewModel
    
    var body: some View {
        ZStack {
            Color(red: 240/255, green: 240/255, blue: 240/255)
                .ignoresSafeArea()
            VStack {
                navigationBar
                VStack {
                    wordField
                    textWarning
                }
                Spacer()
                ButtonFind(vm: vm, isActive: $isActive, changeView: .selectAutor, selectedAuthor: author)
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
                .font(.title)
            Spacer()
        }
        .padding(.bottom)
    }
    
    var wordField: some View {
        VStack{
            WordField(word: $author, placeholder: "Харуки Мураками")
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

struct SelectAuthorFiction_Previews: PreviewProvider {
    static var previews: some View {
        SelectAuthorFiction(vm: ChatBookViewModel(api: ChatGPTAPI(apiKey: "")))
    }
}

