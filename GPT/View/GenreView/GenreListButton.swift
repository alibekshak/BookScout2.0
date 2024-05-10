import SwiftUI


struct GenreListButton: View {
    @StateObject var appState: GenreSelectionViewModel
    @State private var showGenreSelection = false
    
    var body: some View {
        Button {
            showGenreSelection = true
        } label: {
            VStack {
                Image(systemName: "books.vertical")
                    .foregroundColor(showGenreSelection ? .gray : .black)
                    .font(.title)
            }
        }
        .fullScreenCover(isPresented: $showGenreSelection) {
            GenreSelectionView(viewModel: appState)
        }
    }
}

struct GenreListButton_Previews: PreviewProvider {
    static var previews: some View {
        GenreListButton(appState: GenreSelectionViewModel())
    }
}

