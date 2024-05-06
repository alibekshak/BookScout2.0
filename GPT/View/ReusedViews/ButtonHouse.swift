import SwiftUI

struct ButtonHouse: View {
    @Environment(\.dismiss) var dismiss
    @State private var isTapped = false
    private let originalColor = Color.black
    
    var body: some View {
        VStack {
            Image(systemName: "house")
                .foregroundColor(isTapped ? .gray : originalColor)
                .font(.title)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isTapped = true
                        dismiss()
                    }
                }
        }
    }
}

struct ButtonHouse_Previews: PreviewProvider {
    static var previews: some View {
        ButtonHouse()
    }
}








