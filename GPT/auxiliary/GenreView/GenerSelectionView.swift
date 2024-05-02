import SwiftUI

struct GenreSelectionView: View {
    @Binding var selectedGenres: Set<BookGenre>
    @Binding var isGenreSelectionCompleted: Bool
    
    @StateObject var appState: AppStateViewModel
    
    @State private var temporarySelectedGenres: Set<BookGenre> = []
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(red: 240/255, green: 240/255, blue: 240/255)
                .edgesIgnoringSafeArea(.all)
            VStack {
                dismissButton
                textInfo
                scrollView
                buttonNext
            }
            .navigationBarHidden(true)
            .onAppear {
                temporarySelectedGenres = selectedGenres
                if let selectedGenresData = UserDefaults.standard.data(forKey: "selectedGenres") {
                    if let selectedGenres = try? JSONDecoder().decode(Set<BookGenre>.self, from: selectedGenresData) {
                        temporarySelectedGenres = selectedGenres
                    }
                }
            }
            .onChange(of: temporarySelectedGenres) { newGenres in
                let genresData = try? JSONEncoder().encode(newGenres)
                UserDefaults.standard.set(genresData, forKey: "selectedGenres")
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
            .disabled(temporarySelectedGenres.isEmpty)
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
                    if temporarySelectedGenres.contains(genre) {
                        temporarySelectedGenres.remove(genre)
                    } else {
                        temporarySelectedGenres.insert(genre)
                    }
                }) {
                    HStack {
                        Text(genre.rawValue)
                            .foregroundColor(.black)
                        if temporarySelectedGenres.contains(genre) {
                            Spacer()
                            Image(systemName: "checkmark.square.fill")
                                .foregroundColor(.gray)
                        } else {
                            Spacer()
                            Image(systemName: "square")
                                .foregroundColor(.gray)
                        }
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
            selectedGenres = temporarySelectedGenres
            isGenreSelectionCompleted = true
            appState.isGenreSelectionCompleted = true
            
            let genresData = try? JSONEncoder().encode(selectedGenres)
            UserDefaults.standard.set(genresData, forKey: "selectedGenres")
            withAnimation {
                dismiss()
            }
        }) {
            Text("Далее")
                .frame(width: 307, height: 44)
                .foregroundColor(Color.white)
                .font(.system(size: 22))
                .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                .cornerRadius(10)
                .padding()
        }
        .disabled(temporarySelectedGenres.isEmpty)
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
