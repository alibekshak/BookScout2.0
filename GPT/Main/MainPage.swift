import SwiftUI


struct MainPages: View {
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @State private var selectedGenres: Set<BookGenre> = []
    
    var body: some View {
        NavigationView {
                    MainPage(selectedGenres: $selectedGenres, favoritesViewModel: favoritesViewModel) // Передаем selectedGenres здесь
                        .navigationBarTitle("")
                }
                .navigationBarBackButtonHidden(true)
    }
}


struct MainPage: View {
    @Binding var selectedGenres: Set<BookGenre>
    @ObservedObject var favoritesViewModel: FavoritesViewModel
    @ObservedObject var vm = ChatBlogsViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY")) // in this place nead to add API_KEY
    @State private var isActive: Bool = false
    @StateObject var vmfavorite = ChatCategoryViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY"), category: "CATEGORY_VALUE")
    @State private var isFavoritesListPresented = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack(alignment: .leading) {
            Color(red: 240/255, green: 240/255, blue: 240/255)
            
            VStack {
                Spacer()
                HStack(spacing: 115){
                    VStack(alignment: .leading) {
                        Text("BookScout")
                            .font(.custom("SanFranciscoPro", size: 36))
                    }
                    .foregroundColor(Color.black)
                    
             
                        Button(action: {
                            // Show the favorites list
                            isFavoritesListPresented = true
                        }) {
                            Image(systemName: "bookmark")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                        }
                    
                }
                .padding(.top, 40)
                .padding(.bottom, 15)
                .offset(y: 10)
                
                ScrollView(.vertical, showsIndicators: false) {

                    VStack{
                        VStack{
                            Text("Жанры и темы")
                                .font(.custom("SanFranciscoPro", size: 22))
                        }
                        .foregroundColor(Color.black)
                        .padding(.leading, -165)
                        .offset(y: 10)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: -13) {
                                ButtonsForTransition(destination: CategoryFiction(), image: "choice_fiction", title: "Художественная литература")
                                ButtonsForTransition(destination: CategoryNonFiction(), image: "choice_nonfic1", title: "Нон-фикшн литература")
                                ButtonsForTransition(destination: SelectAuthorFiction(), image: "authors", title: "Найти по автору")
                                ButtonsForTransition(destination: SameBookFiction(), image: "same_book", title: "Похожие книги")
                            }
                            .padding(.horizontal, 15)
                        }
                    }
                    .padding(.top, 15)
                    
                    
                    VStack{
                        Text("Блог о книгах")
                            .font(.custom("SanFranciscoPro", size: 22))
                    }
                    .foregroundColor(Color.black)
                    .padding(.leading, -165)
                    .offset(y: 40)
                    
                    LazyVStack(spacing: 1) {
                        Blog(vm: vm, isActive: $isActive, image: "blog", text2: "Топ 3 книг которые,", text3: "стоит прочитать", text_send: "Рекомендуй 3 книг которые, стоит прочитать, напищи интерестный факт об авторах данных книг. Так же расскажи подробно почему ты выбрал эти книги")
                        Blog(vm: vm, isActive: $isActive, image: "blog2", text2: "Книги о жизни", text3: nil, text_send: "Рекамендуй 3 книги о жизнe, кратко дай интерестную информацию об авторе. Так же расскажи подробно почему ты выбрал эти книги")
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 15)
                }
                
                
                VStack{
                  
                        Rectangle()
                            .fill(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.7))
                            .frame(height: 1) // Высота линии
                            .padding(.top, -9) // Отступ сверху, чтобы линия отображалась выше остальных элементов
                            .padding(.horizontal, -95) // Отступы по горизонтали, чтобы линия была шире
                    
                    HStack(spacing: 90) {
                        
                        
                        ChatButtonView()

                        
                        GenreListViewMenu()
                        
                    }
                    .padding(.top, -25)
                }

            }
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isFavoritesListPresented) {
                    FavoritesListView(favoriteItems: $vmfavorite.favoritesViewModel.favoriteItems)
                }
    }
}


struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPages()
    }
}


