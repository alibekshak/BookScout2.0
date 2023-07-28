import SwiftUI


struct GenreListViewMenu: View {
    @StateObject private var appState = AppState()
    @State private var showGenreSelection = false // State to toggle the visibility of the GenreSelectionView
    
    
    var body: some View {
        VStack {
            Image(systemName: "books.vertical")
                .foregroundColor(.black)
                .font(.title)
                .onTapGesture {
                    showGenreSelection = true // Set the state to true to show the GenreSelectionView
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

