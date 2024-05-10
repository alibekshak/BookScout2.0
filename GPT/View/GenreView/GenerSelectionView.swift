import SwiftUI

struct GenreSelectionView: View {
    
    @StateObject var viewModel: GenreSelectionViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            CustomColors.backgroundColor
                .ignoresSafeArea()
            VStack {
                dismissButton
                textInfo
                scrollView
                buttonNext
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadGenresFromUserDefaults()
            }
            .onChange(of: viewModel.selectedGenres) { newGenres in
                viewModel.addNewGenres(newGenres: newGenres)
            }
        }
    }
    
    var dismissButton: some View {
        HStack {
            Spacer()
            Button {
                withAnimation {
                    dismiss()
                }
            } label: {
                Image(systemName: "xmark")
                    .font(Font.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
            }
            .disabled(viewModel.selectedGenres.isEmpty)
        }
        .padding(.trailing, 30)
        .padding(.bottom)
    }
    
    var textInfo: some View {
        VStack {
            Text("Выбор жанров повлияет на ход диалога о книгах или авторе")
                .padding(.horizontal, 40)
            Text("Выберите жанры:")
                .padding(.top, 20)
        }
        .font(.headline)
        .foregroundColor(.black)
    }
    
    var scrollView: some View {
        ScrollView {
            ForEach(BookGenre.allCases, id: \.self) { genre in
                Button(action: {
                    if viewModel.selectedGenres.contains(genre) {
                        viewModel.selectedGenres.remove(genre)
                    } else {
                        viewModel.selectedGenres.insert(genre)
                    }
                }) {
                    HStack {
                        Text(genre.rawValue)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: viewModel.selectedGenres.contains(genre) ? "checkmark.square.fill" : "square")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 80)
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(.vertical, 35)
    }
    
    var buttonNext: some View {
        Button(action: {
            withAnimation {
                dismiss()
            }
        }) {
            Text("Далее")
                .frame(width: 307, height: 44)
                .foregroundColor(Color.white)
                .font(.system(size: 22))
                .background(CustomColors.customBlack)
                .cornerRadius(10)
                .padding()
        }
        .disabled(viewModel.selectedGenres.isEmpty)
    }
}

enum BookGenre: String, CaseIterable, Codable {
    case fantasy = "Фэнтези"
    case mystery = "Мистика"
    case romance = "Романы"
    case poetry = "Поэзия"
    case plays = "Пьесы"
    case stories = "Рассказы"
    case detective = "Детектив"
    case fantastic = "Фантастика"
    case horror = "Хоррор"
    case story = "Повесть"
    case novel = "Новеллы"
    case finance = "Финансы"
    case biography = "Биография"
    case memuar = "Мемуары"
    case philosophy = "Философия"
    case business = "Бизнес"
    case psychology = "Психология"
    case culture = "Искусство"
    case sport = "Спорт"
}
