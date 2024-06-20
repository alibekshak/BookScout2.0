import SwiftUI

struct MainPage: View {
    
    var API = APIManager.shared.api
    
    @StateObject var chatBlogsViewModel = ChatBlogsViewModel(api: APIManager.shared.api)
    @StateObject var favoritesViewModel = FavoritesViewModel()
    
    @State var isActiveBlog: Bool = false
    @State var isActiveBlog2: Bool = false
    @State var isFavoritesListPresented = false
    @State var isFictionPresentend: Bool = false
    @State var isNonFictionPresented: Bool = false
    @State var isAuthorPresented: Bool = false
    @State var isSameBookPresented: Bool = false
    
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
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $isFavoritesListPresented) {
            FavoritesListView(viewModel: favoritesViewModel)
        }
    }
    
    var appTitle: some View {
        HStack {
            Text("BookScout")
                .font(Font.manropeExtraBold_36)
                .foregroundColor(Color.black)
            Spacer()
            Button(action: {
                isFavoritesListPresented = true
            }) {
                Image(systemName: "bookmark")
                    .foregroundColor(.black)
                    .font(.system(size: 32, weight: .semibold))
            }
        }
        .padding(.top)
        .padding(.bottom, 24)
    }
    
    // MARK: mainFanction
    
    var mainFanction: some View {
        VStack(alignment: . leading, spacing: 12) {
            Text("Жанры и темы")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Color.black)
            HStack {
                fictionButton
                Spacer()
                nonFictionButton
            }
            HStack {
                authorButton
                Spacer()
                findBookButton
            }
        }
    }
    
    var fictionButton: some View {
        Button {
            withAnimation {
                isFictionPresentend = true
            }
        } label: {
            NewIconView(
                image: "books.vertical",
                title: "Литература",
                backgroundColor: CustomColors.darkGray,
                viewState: .standard
            )
        }
        .navigationDestination(isPresented: $isFictionPresentend) {
            CategoriesView(
                viewModel: CategoriesViewModel(categoryName: .fiction),
                API: API
            )
        }
    }
    
    var nonFictionButton: some View {
        Button {
            withAnimation {
                isNonFictionPresented = true
            }
        } label: {
            NewIconView(
                image: "books.vertical.fill",
                title: "Нон-фикшн",
                backgroundColor: CustomColors.darkGray,
                viewState: .standard
            )
        }
        .navigationDestination(isPresented: $isNonFictionPresented) {
            CategoriesView(
                viewModel: CategoriesViewModel(categoryName: .nonFiction),
                API: API)
        }
    }
    
    var authorButton: some View {
        Button {
            withAnimation {
                isAuthorPresented = true
            }
        } label: {
            NewIconView(image: "character.book.closed.fill", title: "Автор книги", backgroundColor: CustomColors.darkGray, viewState: .standard)
        }
        .navigationDestination(isPresented: $isAuthorPresented) {
            SelectAuthorFiction()
        }
    }
    
    var findBookButton: some View {
        Button {
            isSameBookPresented = true
        } label: {
            NewIconView(image: "text.book.closed.fill", title: "Похожие книги", backgroundColor: CustomColors.darkGray, viewState: .standard)
        }
        .navigationDestination(isPresented: $isSameBookPresented) {
            SameBookFiction()
        }
    }
    
    // MARK: blogsPart
    var blogsPart: some View {
        VStack(alignment: .leading, spacing: 12) {
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
            withAnimation {
                isActiveBlog = true
                Task {
                    await chatBlogsViewModel.sentTextWorthReading()
                }
            }
        } label: {
            NewIconView(image: "text.bubble.fill", title: "Топ 3 книг которые стоит прочитать", backgroundColor: CustomColors.customBlue, viewState: .alternative)
        }
        .navigationDestination(isPresented: $isActiveBlog) {
            ChatBlogsView(chatBlogsViewModel: chatBlogsViewModel)
        }
    }
    
    var blogButton2: some View {
        Button {
            withAnimation {
                isActiveBlog2 = true
                Task {
                    await chatBlogsViewModel.sentBooksAboutLife()
                }
            }
        } label: {
            NewIconView(image: "text.quote", title: "Книги о жизни", backgroundColor: CustomColors.customBlue, viewState: .alternative)
        }
        .navigationDestination(isPresented: $isActiveBlog2) {
            ChatBlogsView(chatBlogsViewModel: chatBlogsViewModel)
        }
    }
}


struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}


