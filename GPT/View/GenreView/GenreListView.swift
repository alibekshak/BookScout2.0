import SwiftUI


struct GenreListViewMenu: View {
    @StateObject var appState: GenreSelectionViewModel
    @State private var showGenreSelection = false
    
    var body: some View {
        VStack {
            Image(systemName: "books.vertical")
                .foregroundColor(showGenreSelection ? .gray : .black)
                .font(.title)
        }
        .onTapGesture {
            showGenreSelection = true
            
        }
        .fullScreenCover(isPresented: $showGenreSelection) {
            GenreSelectionView(viewModel: appState)
        }
    }
}

struct GenreListViewMenu_Previews: PreviewProvider {
    static var previews: some View {
        GenreListViewMenu(appState: GenreSelectionViewModel())
    }
}

