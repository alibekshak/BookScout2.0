import SwiftUI

struct MainPage: View {
    
    var API = ChatGPTAPI(apiKey: "PROVIDE_API_KEY")
    
    @StateObject var vm = ChatBlogsViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY"))
    @StateObject var favoritesListViewModel = FavoritesListViewModel()
    @StateObject var chatBookViewModel = ChatBookViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY"))
    
    @State var isActiveBlog: Bool = false
    @State var isActiveBlog2: Bool = false
    @State var isFavoritesListPresented = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            CustomColors.backgroundColor
                .ignoresSafeArea()
            VStack(spacing: .zero) {
                appTitle
                ScrollView(showsIndicators: false) {
                    mainFanction
                    blogsPart
                }
            }
            .padding(.horizontal, 30)
        }
        .sheet(isPresented: $isFavoritesListPresented) {
            FavoritesListView(viewModel: favoritesListViewModel)
        }
    }
    
    var appTitle: some View {
        HStack {
            Text("BookScout")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Color.black)
            Spacer()
            Button(action: {
                isFavoritesListPresented = true
            }) {
                Image(systemName: "bookmark")
                    .foregroundColor(.black)
                    .font(.title)
            }
        }
        .padding(.bottom, 24)
    }
    
    var mainFanction: some View {
        VStack(spacing: 12) {
            Text("Жанры и темы")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Color.black)
            HStack {
                fictionButton
                Spacer()
                nonfictionButton
            }
            HStack {
                avtorButton
                Spacer()
                findBookButton
            }
        }
    }
    
    var fictionButton: some View {
        Button {
            
        } label: {
            NewIconView(image: "books.vertical", title: "Литература")
        }
    }
    
    var nonfictionButton: some View {
        Button {
            
        } label: {
            NewIconView(image: "books.vertical.fill", title: "Нон-фикшн")
        }
    }
    
    var avtorButton: some View {
        Button {
            
        } label: {
            NewIconView(image: "character.book.closed.fill", title: "Автор книги")
        }
    }
    
    var findBookButton: some View {
        Button {
            
        } label: {
            NewIconView(image: "text.book.closed.fill", title: "Похожие книги")
        }
    }
    
    var blogsPart: some View {
        VStack(spacing: 12) {
            Text("Блог о книгах")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Color.black)
            blogButton1
            blogButton2
        }
        .padding(.top)
    }
    
    var blogButton1: some View {
        Button {
            
        } label: {
            NewIconView(image: "text.bubble.fill", title: "Топ 3 книг которые стоит прочитать")
        }
    }
    
    var blogButton2: some View {
        Button {
            
        } label: {
            NewIconView(image: "text.quote", title: "Книги о жизни")
        }
    }
    
    var mainFunctions: some View {
        VStack(alignment: .leading) {
            Text("Жанры и темы")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Color.black)
                .padding(.horizontal, 30)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: -12) {
                    ButtonsForTransition(destination: CategoriesView(API: API, categoryName: .fiction), image: "choice_fiction", title: "Художественная литература")
                    ButtonsForTransition(destination: CategoriesView(API: API, categoryName: .nonFiction), image: "choice_nonfic1", title: "Нон-фикшн литература")
                    ButtonsForTransition(destination: SelectAuthorFiction(vm: chatBookViewModel), image: "authors", title: "Найти по автору")
                    ButtonsForTransition(destination: SameBookFiction(vm: chatBookViewModel), image: "same_book", title: "Похожие книги")
                }
                .padding(.horizontal, 15)
            }
        }
        .padding(.top)
    }
    
    var blogs: some View {
        VStack(alignment: .leading) {
            Text("Блог о книгах")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Color.black)
                .padding(.horizontal, 30)
            
            LazyVStack(spacing: 1) {
                Blog(vm: vm, isActive: $isActiveBlog, image: "blog", text: "Топ 3 книг которые стоит прочитать", text_send: "Рекомендуй 3 книг которые, стоит прочитать, напищи интерестный факт об авторах данных книг. Так же расскажи подробно почему ты выбрал эти книги")
                    .navigationDestination(isPresented: $isActiveBlog) {
                        ChatBlogsView(vm: vm)
                    }
                Blog(vm: vm, isActive: $isActiveBlog2, image: "blog2", text: "Книги о жизни", text_send: "Рекамендуй 3 книги о жизнe, кратко дай интерестную информацию об авторе. Так же расскажи подробно почему ты выбрал эти книги")
                    .navigationDestination(isPresented: $isActiveBlog2) {
                        ChatBlogsView(vm: vm)
                    }
            }
            .padding(.bottom)
            .padding(.horizontal, 15)
        }
        .padding(.top)
    }
}


struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}


