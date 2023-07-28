import SwiftUI

struct ButtonFind: View {
    var title: String = "Найти"
    var selectedAuthor: String
    var vm: Chat_SameBookViewModel
    @Binding var isActive: Bool
    
    var body: some View {
        NavigationLink(destination: Chat_SameBookView(vm: vm)) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 307, height: 44)
                
                Text(title)
                    .frame(width: 307, height: 44)
                    .foregroundColor(Color.white)
                    .font(.system(size: 22))
                    .background(Color(red: 30/255, green: 30/255, blue: 30/255))
            }
            .cornerRadius(10)
        }
        .simultaneousGesture(TapGesture().onEnded {
            sendSelectedCategory()
        })
    }

    private func sendSelectedCategory() {
        let text = "Хочу прочитать \(selectedAuthor), дай рецензию как минимум на 4 книги, с которых стоит начать читать данного автора,  так же обоснуй почему ты выбрал эти книги и еще расскажи один интерестный факт об \(selectedAuthor)"
        Task {
            await vm.send(text: text)
            isActive = true
        }
    }
}


struct ButtonFindSameBook: View {
    var title: String = "Найти"
    var selectedBook: String
    var selectedAuthor: String
    var vm: Chat_SameBookViewModel
    @Binding var isActive: Bool
    
    var body: some View {
        NavigationLink(destination: Chat_SameBookView(vm: vm)) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 307, height: 44)
                
                Text(title)
                    .frame(width: 307, height: 44)
                    .foregroundColor(Color.white)
                    .font(.system(size: 22))
                    .background(Color(red: 30 / 255, green: 30 / 255, blue: 30 / 255))
            }
            .cornerRadius(10)
        }
        .simultaneousGesture(TapGesture().onEnded {
            sendSelectedCategory()
        })
    }

    private func sendSelectedCategory() {
        let text = "Читал \(selectedAuthor) - \(selectedBook) на основании этого  предложи 5 стилистический похожие книги, так же напиши почему ты выбрал эти книги"
        Task {
            await vm.send(text: text)
            isActive = true
        }
    }
}

