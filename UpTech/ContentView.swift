//
//  ContentView.swift
//  UpTech
//
//  Created by Nikita Lobanov on 28.05.2021.
//

import SwiftUI

struct ContentView: View {
    let viewModel = ProductsSearchViewModel()

    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                viewModel.testRequest()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }


}
