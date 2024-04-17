import SwiftUI

struct SelectAuthorFiction1: View {
    var body: some View {
        NavigationView {
            SelectAuthorFiction()
                .navigationBarTitle("")
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SelectAuthorFiction: View {
    
    @State private var isActive: Bool = false
    @State private var author = ""
    @State private var book = ""
    @StateObject var vm = ChatBookViewModel(api: ChatGPTAPI(apiKey: "")) // in this place nead to add API_KEY
    
    var body: some View {
        ZStack{
            Color(red: 240/255, green: 240/255, blue: 240/255)
            VStack{
                

                Chevron()
                .padding(.top, 55)
                .padding(.leading, -170)
                
                VStack{
                    Text("Имя автора")
                        .foregroundColor(Color.black)
                        .font(.custom("SanFrancisco", size: 36))
                        
                }
                .padding(.leading, -140)
                .offset(y: 55)
                
                VStack{
                    WordField(word: $author, placeholder: "Харуки Мураками")
                }
                .offset(y: 70)

                
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
                .offset(y: 110)
                
                Spacer()
                Spacer()

                ButtonFind(vm: vm, isActive: $isActive, selectedAuthor: author)
                .offset(y: -80)
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SelectAuthorFiction_Previews: PreviewProvider {
    static var previews: some View {
        SelectAuthorFiction1()
    }
}

