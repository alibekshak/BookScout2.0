import SwiftUI

@main
struct GPTApp: App {
    
    @StateObject private var appState = GenreSelectionViewModel()
    
    @State var isAppLoaded: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isAppLoaded {
                if appState.selectedGenres.isEmpty {
                    GenreSelectionView(viewModel: appState)
                } else {
                    MainPages(appState: appState)
                }
            } else {
                LaunchScreen()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            self.isAppLoaded = true
                        }
                    }
                }
            }
        }
    }
}
