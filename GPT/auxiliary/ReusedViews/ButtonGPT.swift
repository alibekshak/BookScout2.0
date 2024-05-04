import SwiftUI

enum ChangeView {
    case sameBook
    case selectAutor
}

struct ButtonFind: View {
    
    @StateObject var vm: ChatBookViewModel
    
    @Binding var isActive: Bool
    
    @State var changeView: ChangeView
    
    var title: String = "Найти"
    var selectedAuthor: String
    var selectedBook: String = ""

    var body: some View {
        NavigationLink(destination: ChatBookView(vm: vm)) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(red: 30/255, green: 30/255, blue: 30/255))
                Text(title)
                    .foregroundColor(Color.white)
                    .font(.system(size: 22))
            }
            .frame(height: 44)
        }
        .simultaneousGesture(TapGesture().onEnded {
            sendSelectedCategory()
        })
    }

    private func sendSelectedCategory() {
        var text = ""
        switch changeView {
        case .sameBook:
            text = "Хочу прочитать \(selectedAuthor), дай рецензию как минимум на 4 книги, с которых стоит начать читать данного автора,  так же обоснуй почему ты выбрал эти книги и еще расскажи один интерестный факт об \(selectedAuthor)"
        case .selectAutor:
            text = "Читал \(selectedAuthor) - \(selectedBook) на основании этого  предложи 5 стилистический похожие книги, так же напиши почему ты выбрал эти книги"
        }
        
        Task {
            await vm.send(text: text)
            isActive = true
        }
    }
}



