//
//  СompilationView.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import UIKit

final class CompilationView: UIView {
    private static let cornerRadius: CGFloat = 14

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()


    init(type: Compilation) {
        super.init(frame: .zero)

        titleLabel.text = type.title
        imageView.image = type.image
        setupLayout()
        setupView(isHighlightedBorder: type.isHighlightedBorder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(isHighlightedBorder: Bool) {
        self.applyShadow(with: Shadows.standardWideShadow)
        layer.cornerRadius = Self.cornerRadius
        if isHighlightedBorder {
            layer.borderWidth = 4
            layer.borderColor = UIColor(hex: "#50dded")?.cgColor
        }
    }

    private func setupLayout() {
        [titleLabel, imageView].forEach(addSubview)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.snp.height).multipliedBy(0.8)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
        }
    }
}
