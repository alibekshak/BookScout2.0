import SwiftUI

struct GenreSelectionView: View {
    @Binding var selectedGenres: Set<BookGenre>
    @Binding var isGenreSelectionCompleted: Bool
    @EnvironmentObject var appState: AppState

    @State private var temporarySelectedGenres: Set<BookGenre> = []
    @Environment(\.dismiss) var dismiss

    init(selectedGenres: Binding<Set<BookGenre>>, isGenreSelectionCompleted: Binding<Bool>) {
        _selectedGenres = selectedGenres
        _isGenreSelectionCompleted = isGenreSelectionCompleted
        _temporarySelectedGenres = State(initialValue: selectedGenres.wrappedValue)

        let selectedGenresSet = Set(selectedGenres.wrappedValue)
        BookGenre.allCases.forEach { genre in
            if selectedGenresSet.contains(genre) {
                temporarySelectedGenres.insert(genre)
            }
        }
    }

    var body: some View {
        ZStack {
            Color(red: 240/255, green: 240/255, blue: 240/255)
                .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Text("Выбор жанров повлияет на ход диалога о книгах или авторе")
                        .padding(.horizontal, 40)
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("Выберите жанры:")
                        .font(.headline)
                        .padding(.top, 20)
                        .foregroundColor(.black)

                    ScrollView { // Add ScrollView around the ForEach loop
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
                                            .foregroundColor(.blue)
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
                    }.padding(.vertical, 35)
                   
                    Spacer()
                    

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
                    .disabled(temporarySelectedGenres.isEmpty) // Disable the button if no genres are selected
                }
                .navigationBarTitle("", displayMode: .inline)
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
