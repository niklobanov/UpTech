//
//  Compilation.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import UIKit

enum Compilation: String {
    case diabetes, covid, allergy, efficiency

    var title: String {
        switch self {
        case .allergy:
            return "Аллергия"
        case .covid:
            return "COVID-19"
        case .diabetes:
            return "Диабет"
        case .efficiency:
            return "С проверенной эффективностью"
        }
    }

    var image: UIImage? {
        return UIImage(named: "\(self.rawValue)_icon")
    }

    var isHighlightedBorder: Bool {
        switch self {
        case .efficiency:
            return true
        default:
            return false
        }
    }
}
