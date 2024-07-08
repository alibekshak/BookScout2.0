import SwiftUI

@main
struct GPTApp: App {
    
    @StateObject private var appState = GenreSelectionViewModel()
    
    @State var isAppLoaded: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if appState.userDefaultsEmpty {
                GenreSelectionView(viewModel: appState, states: .firstOpen)
            } else {
                TabViewMain(appState: appState)
            }
        }
    }
}
