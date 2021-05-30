//
//  UpTechApp.swift
//  UpTech
//
//  Created by Nikita Lobanov on 28.05.2021.
//

import SwiftUI

@main
struct UpTechApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
        }
    }
}

struct HomeView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<HomeView>) -> HomeViewController {
        return HomeViewController()
    }

    func updateUIViewController(_ uiViewController: HomeViewController, context: UIViewControllerRepresentableContext<HomeView>) {

    }
}
