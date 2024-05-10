import SwiftUI

@main
struct GPTApp: App {
    
    @StateObject private var appState = GenreSelectionViewModel()
    
    var body: some Scene {
        WindowGroup {
            if appState.selectedGenres.isEmpty {
                GenreSelectionView(viewModel: appState)
            } else {
                MainPages(appState: appState)
            }
        }
    }
}
