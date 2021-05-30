//
//  DetailView.swift
//  UpTech
//
//  Created by Anton Kondrashov on 30.05.2021.
//

import SwiftUI

struct DetailView: View {
    let jsonURL = "https://cf.geekdo-images.com/thumb/img/sD_qvrzIbvfobJj0ZDAaq-TnQPs=/fit-in/200x150/pic2649952.jpg"

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                RemoteImage(url: jsonURL)
                    .aspectRatio(contentMode: .fit)
                ZStack {
                    ButtonBackgroundShape(cornerRadius: 14, style: .circular)
                        .fill(Color.purpleColor)
                        .frame(height: 40)

                    Text("Дешевле")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 32)
                        .padding([.top, .bottom], 2)
                }
                .fixedSize(horizontal: true, vertical: false)
                .offset(y: 40)
            }

            VStack(alignment: .leading) {
                Text("Мелаксен, таблетки 3 мг, 24 шт.")

                HStack {
                    StarsView(starsFilled: 5)

                    Text("35 отзывов")
                }
            }
            .offset(x: 16)

            Text("Аналоги")
                .font(.system(.headline))
                .offset(x: 15, y: 16)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [.init(.fixed(269), spacing: 8)]) {
                    ForEach(1..<10) { element in
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .cornerRadius(16)
                                .shadow(radius: 2)

                            VStack {
                                ZStack(alignment: .topLeading) {
                                    RemoteImage(url: jsonURL)
                                        .aspectRatio(contentMode: .fit)
                                    ZStack {
                                        ButtonBackgroundShape(cornerRadius: 14, style: .circular)
                                            .fill(Color.purpleColor)
                                            .frame(height: 24)

                                        Text("Дешевле")
                                            .font(.system(.footnote, design: .rounded))
                                            .foregroundColor(.white)
                                            .padding([.leading, .trailing], 16)
                                            .padding([.top, .bottom], 2)
                                    }
                                    .fixedSize(horizontal: true, vertical: false)
                                    .offset(y: 20)
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Мирамистин р-р для местн применения 0.01%, флакон с распи")
                                        .font(.system(.footnote))
                                        .lineLimit(3)
                                    StarsView(starsFilled: 3)

                                    HStack {
                                        Text("245 ₽")
                                        Spacer()
                                        Button(
                                            action: {},
                                            label: {
                                                Image("buy")
                                                    .frame(width: 32, height: 32)
                                            }
                                        )
                                    }
                                }
                                .padding(8)

                                Spacer()
                            }
                        }
                    }
                    .frame(width: 169)
                }
                .padding([.top, .bottom], 8)
                .padding(.leading, 16)
            }
            Spacer()
        }
    }
}

struct ButtonBackgroundShape: Shape {

    var cornerRadius: CGFloat
    var style: RoundedCornerStyle

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        return Path(path.cgPath)
    }
}

struct StarsView: View {
    let starsFilled: Int

    init(starsFilled: Int) {
        self.starsFilled = starsFilled
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<starsFilled) {
                [Image](
                    repeating: Image(systemName: "star.fill"),
                    count: 5
                )[$0]
                .foregroundColor(.starColor)
                .frame(width: 16, height: 16)
            }

            ForEach(starsFilled..<5) {
                [Image](
                    repeating: Image(systemName: "star.fill"),
                    count: 5
                )[$0]
                .foregroundColor(.gray)
                .frame(width: 16, height: 16)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView()
        }
    }
}

struct RemoteImage: View {
    private enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading

        init(url: String) {
            guard let parsedURL = URL(string: url) else {
                fatalError("Invalid URL: \(url)")
            }

            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }

                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }

    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image

    var body: some View {
        selectImage()
            .resizable()
    }

    init(
        url: String,
        loading: Image = Image(systemName: "photo"),
        failure: Image = Image(systemName: "multiply.circle")
    ) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
    }

    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}
