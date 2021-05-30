//
//  DetailView.swift
//  UpTech
//
//  Created by Anton Kondrashov on 30.05.2021.
//

import SwiftUI

enum ProductBadge {
    case effective
    case cheapest
    case safe
    case none

    init(isEffective: Bool, isCheapest: Bool, isSafe: Bool) {
        switch (isEffective, isCheapest, isSafe) {
        case (true, _, _):
            self = .effective
        case (_, true, _):
            self = .cheapest
        case (_, _, true):
            self = .safe
        default:
            self = .none
        }
    }

    var directTitle: String? {
        switch self {
        case .effective:
            return "Эффективный"
        case .cheapest:
            return "Самый дешевый"
        case .safe:
            return "Безопасный"
        default:
            return nil
        }
    }

    var analogueTitle: String? {
        switch self {
        case .effective:
            return "Эффективнее"
        case .cheapest:
            return "Дешевле"
        case .safe:
            return "Безопаснее"
        default:
            return nil
        }
    }
}

struct Product {
    let name: String
    let badge: ProductBadge
}

struct DetailView: View {
    let jsonURL = "https://cf.geekdo-images.com/thumb/img/sD_qvrzIbvfobJj0ZDAaq-TnQPs=/fit-in/200x150/pic2649952.jpg"

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                RemoteImage(
                    url: jsonURL
                )
                .aspectRatio(contentMode: .fit)
                BadgeView(
                    text: "Эффективный",
                    height: 40,
                    padding: 32
                )
                .offset(y: 40)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Мелаксен, таблетки 3 мг, 24 шт.")
                    .fontWeight(.bold)

                HStack {
                    StarsView(starsFilled: 5)

                    Text("35 отзывов")
                        .foregroundColor(.gray)
                        .font(.system(.caption2))
                }
            }
            .offset(x: 16)

            Text("Аналоги")
                .font(.system(.headline))
                .offset(x: 15, y: 16)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [.init(.fixed(269), spacing: 8)]) {
                    ForEach(1..<10) { element in
                        AnalogueView(
                            imageUrl: jsonURL,
                            badgeText: "Дешевле",
                            drugName: "Мирамистин р-р для местн применения 0.01%, флакон с распи",
                            price: "245 ₽"
                        )
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

struct BadgeView: View {
    let text: String
    let height: CGFloat
    let padding: CGFloat

    var body: some View {
        ZStack {
            RoundedSpecificCornersRectangle(cornerRadius: 14, style: .circular)
                .fill(Color.purpleColor)
                .frame(height: height)

            Text(text)
                .font(.system(.footnote, design: .rounded))
                .foregroundColor(.white)
                .padding([.leading, .trailing], padding)
                .padding([.top, .bottom], 2)
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct AnalogueView: View {
    let imageUrl: String
    let badgeText: String
    let drugName: String
    let starsFilled: Int = 4
    let price: String

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .cornerRadius(16)
                .shadow(radius: 2)

            VStack {
                ZStack(alignment: .topLeading) {
                    RemoteImage(url: imageUrl)
                        .aspectRatio(contentMode: .fit)
                    BadgeView(
                        text: badgeText,
                        height: 24,
                        padding: 16
                    )
                    .offset(y: 20)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(drugName)
                        .font(.system(.footnote))
                        .lineLimit(3)
                    StarsView(starsFilled: starsFilled)

                    HStack {
                        Text(price)
                        Spacer()
                        Image("buy")
                            .frame(width: 32, height: 32)
                    }
                }
                .padding(8)

                Spacer()
            }
        }
    }
}

struct RoundedSpecificCornersRectangle: Shape {
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
