//
//  UINavigation+Extension.swift
//  UpTech
//
//  Created by Nikita Lobanov on 30.05.2021.
//

import UIKit


extension UINavigationBar {
    func removeBackTitle() {
        self.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
    }
}
