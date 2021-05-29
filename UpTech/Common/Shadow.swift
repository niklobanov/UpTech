//
//  Shadow.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import UIKit

enum Shadows {
    struct ShadowParams {
        let radius: CGFloat
        let offset: CGSize
        let opacity: Float
        let color: CGColor
    }

    static let standardWideShadow = Shadows.ShadowParams(
        radius: 24,
        offset: CGSize(width: 0, height: 2),
        opacity: 0.08,
        color: #colorLiteral(red: 0.1, green: 0.24, blue: 0.42, alpha: 1)
    )

    public static func apply(params: ShadowParams, to view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowOffset = params.offset
        view.layer.shadowRadius = params.radius
        view.layer.shadowOpacity = params.opacity
        view.layer.shadowColor = params.color
    }
}

extension UIView {
    func applyShadow(with params: Shadows.ShadowParams) {
        Shadows.apply(params: params, to: self)
    }
}
