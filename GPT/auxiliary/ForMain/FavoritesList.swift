import SwiftUI

struct FavoritesListView: View {
    
    @StateObject var viewModel: FavoritesListViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            VStack {
                navigationBar
                List {
                    ForEach(viewModel.favoriteItems) { item in
                        Text(item.title)
                    }
                    .onDelete(perform: viewModel.deleteFavoriteItem)
                    .onMove(perform: viewModel.moveFavoriteItem)
                }
                .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
            }
        }
        .onAppear {
            viewModel.refreshFavoriteItems()
        }
    }
    
    var navigationBar: some View {
        HStack(spacing: 50) {
            Button(action: {
                isEditing.toggle()
            }, label: {
                Image(systemName: isEditing ? "line.3.horizontal.decrease" : "line.horizontal.3")
                    .font(.title2)
            })
            Text("Избранное")
                .font(.title)
                .foregroundColor(.black)
                .padding(.leading)
            Button("Закрыть") {
                dismiss()
            }
        }
        .padding(.top)
        .padding(.horizontal)
    }
}

