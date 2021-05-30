//
//  UIImageView+Nuke.swift
//  UpTech
//
//  Created by Nikita Lobanov on 30.05.2021.
//

import UIKit
import Nuke

extension UIImageView {
    func loadImage(with url: URL) {
        Nuke.loadImage(with: url, into: self)
    }

    func load(url: URL, completion: ((Bool) -> Void)? = nil) {
        Nuke.loadImage(
            with: url,
            options: .shared,
            into: self,
            completion: { response in
                completion?((try? response.get().image) != nil)
            }
        )
    }
}
