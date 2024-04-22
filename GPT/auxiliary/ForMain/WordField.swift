import SwiftUI

struct WordField: View {
    @Binding var word: String
    var placeholder: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 2)
            
            TextField(placeholder, text: $word)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
        }
        .frame(height: 44)
        .background(Color(red: 240/255, green: 240/255, blue: 240/255))
    }
}

