import SwiftUI

struct FavoritesListView: View {
    
    @StateObject var viewModel: FavoritesListViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isEditing = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.favoriteItems) { item in
                    Text(item.title)
                }
                .onDelete(perform: viewModel.deleteFavoriteItem)
                .onMove(perform: viewModel.moveFavoriteItem)
            }
            .navigationBarTitle("Избранное")
            .navigationBarItems(trailing: HStack(spacing: 240) {
                Button(action: {
                    isEditing.toggle()
                }, label: {
                    Image(systemName: isEditing ? "arrow.up.arrow.down" : "line.horizontal.3").font(.title2)
                })
                Button("Закрыть") {
                    dismiss()
                }
                .offset(x: -15)
            })
            .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
        }
        .onAppear {
            viewModel.refreshFavoriteItems()
        }
    }
}

