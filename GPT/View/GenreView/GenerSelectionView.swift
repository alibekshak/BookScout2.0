import SwiftUI

enum States {
    case firstOpen
    case genreTab
}

struct GenreSelectionView: View {
    
    @StateObject var viewModel: GenreSelectionViewModel
    
    @State var states: States
    @State var selectGenres: Bool = false
    @State var isShowingNotificationSheet: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            CustomColors.backgroundColor
                .ignoresSafeArea()
            ZStack(alignment: .bottom) {
                VStack {
                    textInfo
                    scrollView
                }
                .padding(.bottom, 70)
                buttonNext
               
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadGenresFromUserDefaults()
            }
            NotificationSheetView(isShowing: $isShowingNotificationSheet)
                .frame(maxHeight: 250)
        }
    }
    
    var textInfo: some View {
        VStack(spacing: 20) {
            Text("Выбор жанров повлияет на ход диалога о книгах или авторе")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            Text("Выберите жанры:")
        }
        .font(.headline)
        .foregroundColor(.black)
        .padding(.top)
    }
    
    var scrollView: some View {
        ScrollView(showsIndicators: false) {
            ForEach(BookGenre.allCases, id: \.self) { genre in
                Button {
                    viewModel.removeOrInsert(genre: genre)
                } label: {
                    HStack {
                        Text(genre.rawValue)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName:
                                viewModel.selectedGenres.contains(genre) ?
                              "checkmark.square.fill" : "square"
                        )
                        .foregroundColor(.gray)
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    var buttonNext: some View {
        Button {
            withAnimation {
                selectGenres = true
                viewModel.addNewGenres(newGenres: viewModel.selectedGenres)
                if states == .genreTab {
                    isShowingNotificationSheet = true
                }
            }
        } label: {
            Text(states == .firstOpen ? "Далее" : "Принять")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(DarkButtonStyle())
        .disabled(viewModel.selectedGenres.isEmpty)
        .padding(.horizontal, 20)
        .padding(.bottom, 4)
    }
}
