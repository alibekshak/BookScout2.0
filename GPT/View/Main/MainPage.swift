import SwiftUI

struct MainPages: View {
    
    var API = ChatGPTAPI(apiKey: "PROVIDE_API_KEY")
    
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @StateObject private var vmfavorite = ChatCategoryViewModel(api:  ChatGPTAPI(apiKey: "PROVIDE_API_KEY"), category: "CATEGORY_VALUE")
    @StateObject var vm = ChatBlogsViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY"))
    @StateObject var favoritesListViewMode = FavoritesListViewModel(vm: FavoritesViewModel())
    @StateObject var appState: GenreSelectionViewModel
    @StateObject var chatViewModel = ChatViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY"))
    @StateObject var chatBookViewModel = ChatBookViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY"))
    
    var body: some View {
        NavigationView {
            MainPage(API: API, favoritesViewModel: favoritesViewModel, vm: vm, vmfavorite: vmfavorite, favoritesListViewModel: favoritesListViewMode, appState: appState, chatViewModel: chatViewModel, chatBookViewModel: chatBookViewModel)
        }
    }
}

struct MainPage: View {
    
    var API: ChatGPTAPI
    
    @StateObject var favoritesViewModel: FavoritesViewModel
    @StateObject var vm: ChatBlogsViewModel
    @StateObject var vmfavorite: ChatCategoryViewModel
    @StateObject var favoritesListViewModel: FavoritesListViewModel
    @StateObject var appState: GenreSelectionViewModel
    @StateObject var chatViewModel: ChatViewModel
    @StateObject var chatBookViewModel: ChatBookViewModel
    
    @State var isActiveBlog: Bool = false
    @State var isActiveBlog2: Bool = false
    @State var isFavoritesListPresented = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                CustomColors.backgroundColor
                    .ignoresSafeArea()
                VStack(spacing: .zero) {
                    appTitle
                    ScrollView(.vertical, showsIndicators: false) {
                        mainFunctions
                        blogs
                    }
                    tabView
                }
            }
        }
        .sheet(isPresented: $isFavoritesListPresented) {
            FavoritesListView(viewModel: favoritesListViewModel)
        }
    }
    
    var appTitle: some View {
        HStack {
            Text("BookScout")
                .font(.system(size: 36))
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
        .padding(.horizontal, 30)
    }
    
    var mainFunctions: some View {
        VStack(alignment: .leading) {
            Text("Жанры и темы")
                .font(.system(size: 22))
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
                .font(.system(size: 22))
                .foregroundColor(Color.black)
                .padding(.horizontal, 30)
            
            LazyVStack(spacing: 1) {
                Blog(vm: vm, isActive: $isActiveBlog, image: "blog", text2: "Топ 3 книг которые,", text3: "стоит прочитать", text_send: "Рекомендуй 3 книг которые, стоит прочитать, напищи интерестный факт об авторах данных книг. Так же расскажи подробно почему ты выбрал эти книги")
                    .navigationDestination(isPresented: $isActiveBlog) {
                        ChatBlogsView(vm: vm)
                    }
                Blog(vm: vm, isActive: $isActiveBlog2, image: "blog2", text2: "Книги о жизни", text3: nil, text_send: "Рекамендуй 3 книги о жизнe, кратко дай интерестную информацию об авторе. Так же расскажи подробно почему ты выбрал эти книги")
                    .navigationDestination(isPresented: $isActiveBlog2) {
                        ChatBlogsView(vm: vm)
                    }
            }
            .padding(.bottom)
            .padding(.horizontal, 15)
        }
        .padding(.top)
    }
    
    var tabView: some View {
        VStack(spacing: 6) {
            Divider()
            HStack(spacing: 90) {
                ChatButtonView(viewModel: chatViewModel)
                GenreListButton(appState: appState)
            }
        }
    }
}


struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPages(appState: GenreSelectionViewModel())
    }
}


