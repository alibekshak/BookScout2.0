import SwiftUI

struct MessageRow: Identifiable {
    let id = UUID()
    
    var isInteractingWithChatGPT: Bool
    
    let sendText: String
    
    var responseText: String?
    
    var responseError: String?
    
    var buttons: [String]?
}
