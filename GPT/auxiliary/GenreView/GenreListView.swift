import SwiftUI


struct GenreListViewMenu: View {
    @StateObject private var appState = AppStateViewModel()
    @State private var showGenreSelection = false
    
    var body: some View {
        VStack {
            Image(systemName: "books.vertical")
                .foregroundColor(.black)
                .font(.title)
                .onTapGesture {
                    showGenreSelection = true
                }
        }
        .fullScreenCover(isPresented: $showGenreSelection) {
            GenreSelectionView(selectedGenres: $appState.selectedGenres, isGenreSelectionCompleted: $appState.isGenreSelectionCompleted)
                .environmentObject(appState)
                
        }
        .padding() 
    }
}

struct GenreListViewMenu_Previews: PreviewProvider {
    static var previews: some View {
        GenreListViewMenu()
    }
}

