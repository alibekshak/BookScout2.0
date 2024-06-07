import SwiftUI

struct FavoritesListView: View {
    
    @StateObject var viewModel: FavoritesViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isEditing = false
    
    var body: some View {
            ZStack {
                CustomColors.backgroundColor
                VStack {
                    navigationBar
                    List {
                        ForEach(viewModel.favoriteItems) { item in
                            Text(item.title)
                        }
                        .onDelete(perform: viewModel.deleteFavoriteItem)
                        .onMove(perform: viewModel.moveFavoriteItem)
                    }
                    .background(CustomColors.backgroundColor)
                    .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
                }
            }
        .onAppear {
            viewModel.refreshFavoriteItems()
        }
    }
    
    var navigationBar: some View {
        HStack {
            Button(action: {
                isEditing.toggle()
            }, label: {
                Image(systemName: isEditing ? "line.3.horizontal.decrease" : "line.horizontal.3")
                    .font(.title2)
            })
            Spacer()
            Text("Избранное")
                .font(.title)
                .foregroundColor(.black)
                .padding(.leading)
            Spacer()
            XmarkButton()
        }
        .padding(.top)
        .padding(.horizontal, 20)
    }
}

