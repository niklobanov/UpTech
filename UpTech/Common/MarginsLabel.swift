//
//  MarginsLabel.swift
//  UpTech
//
//  Created by Nikita Lobanov on 30.05.2021.
//

import UIKit

final class MarginsLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 6, left: 4, bottom: 6, right: 4)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + 8
        let height = superContentSize.height + 12
        return CGSize(width: width, height: height)
        
    }
}
