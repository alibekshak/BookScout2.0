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
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring()) {
                            isTapped = false
                        }
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


struct Chevron: View {
    @State private var showModal = false
    @Environment(\.dismiss) var dismiss
    var body: some View{
        Button(action: {
            goBack()
        }) {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .foregroundColor(.black)
        }
    }
    
    func goBack() {
        dismiss()
    }
}





