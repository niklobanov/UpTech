//
//  UIFont+Extension.swift
//  UpTech
//
//  Created by Nikita Lobanov on 30.05.2021.
//

import UIKit

enum FontName: String {
    case regular = "Sansation-Regular"
    case bold = "Sansation-Bold"
    case italic = "Sansation-Italic"
}

extension UIFont {
    class func uptechFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
    
        switch weight {
        case .bold:
            return UIFont(name: FontName.bold.rawValue, size: size)!
        case .medium:
            return UIFont(name: FontName.italic.rawValue, size: size)!
        case .semibold:
            return UIFont(name: FontName.italic.rawValue, size: size)!
        case .light:
            return UIFont(name: FontName.regular.rawValue, size: size)!
        case .ultraLight:
            return UIFont(name: FontName.regular.rawValue, size: size)!
        case .thin:
            return UIFont(name: FontName.regular.rawValue, size: size)!
        case .bold, .black:
            return UIFont(name: FontName.bold.rawValue, size: size)!
        case .heavy:
            return UIFont(name: FontName.bold.rawValue, size: size)!
        default:
            return UIFont(name: FontName.regular.rawValue, size: size)!
        }
    }
}

