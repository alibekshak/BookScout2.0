import SwiftUI

struct WordField: View {
    
    @Binding var word: String
    
    var placeholder: String
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextField(placeholder, text: $word)
                .focused($isFocused)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
            .stroke(Color.gray, lineWidth: 2)
        )
    }
}

