import SwiftUI

struct SameBookFiction1: View {
    var body: some View {
        NavigationView {
            SameBookFiction()
                .navigationBarTitle("")
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SameBookFiction: View {
    @State private var author = ""
    @State private var book = ""
    @State private var isActive: Bool = false
    @State private var showingSheet = false
    var vm: Chat_SameBookViewModel {
        Chat_SameBookViewModel(api: ChatGPTAPI(apiKey: "CATEGORY_VALUE"), book: book, author: author)} // in this place nead to add API_KEY
    
    var body: some View {
        ZStack{
            Color(red: 240/255, green: 240/255, blue: 240/255)
            
            VStack{

                Chevron()
                .padding(.top, 50)
                .padding(.leading, -170)

                
                VStack{
                    Text("Введите данные:")
                        .foregroundColor(Color.black)
                        .font(.custom("SanFrancisco", size: 36))

                }
                .offset(y: 25)
                .padding(.leading, -40)
                
                VStack(spacing: 20){
                    WordField(word: $author, placeholder: "Харуки Мураками")
                    WordField(word: $book, placeholder: "Норвежский лес")
                }
                .offset(y: 40)

                
                VStack{
                    Text("Иногда искусственный интеллект неправильно переводит книги на русский язык, поэтому рекомендуется использовать англоязычное название книги")
                        .foregroundColor(Color.black.opacity(0.6))
                        .font(.custom("SanFrancisco", size: 16))
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .minimumScaleFactor(0.8)

                }
                .padding(.leading, 30)
                .padding(.trailing, 28)
                .offset(y: 80)
                Spacer()
                
               
                Spacer()
                
                ButtonFindSameBook(selectedBook: book, selectedAuthor: author, vm: vm, isActive: $isActive)
                    .offset(y: -80)

            }
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SameBookFiction_Previews: PreviewProvider {
    static var previews: some View {
        SameBookFiction1()
    }
}

