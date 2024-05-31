import SwiftUI

struct WordField: View {
    
    @Binding var word: String
    
    var placeholder: String
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 2)
            
            TextField(placeholder, text: $word)
                .focused($isFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(EdgeInsets(top: 14, leading: 12, bottom: 14, trailing: 12))
        }
        .frame(height: 44)
        .background(CustomColors.backgroundColor)
    }
}

