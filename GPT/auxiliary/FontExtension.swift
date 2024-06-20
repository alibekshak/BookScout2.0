//
//  FontExtension.swift
//  GPT
//
//  Created by Alibek Shakirov on 20.06.2024.
//

import Foundation
import SwiftUI

public enum Fonts: String {
    case montserratBold = "Montserrat-Bold"
    case montserratBoldItalic = "Montserrat-BoldItalic"
    case montserratExtraBold = "Montserrat-ExtraBold"
    case montserratExtraBoldItalic = "Montserrat-ExtraBoldItalic"
    case manropeExtraBold = "Manrope-ExtraBold"
}

extension Font {
    static func custom(_ name: Fonts, size: CGFloat) -> Font {
        return Font.custom(name.rawValue, size: size)
    }
    
    // MARK: MontserratExtraBoldItalic
    static var manropeExtraBold_36: Font {
        return .custom(.montserratExtraBoldItalic, size: 36)
    }
}
