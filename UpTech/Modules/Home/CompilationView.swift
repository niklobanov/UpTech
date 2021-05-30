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
        label.font = UIFont.uptechFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.layer.cornerRadius = Self.cornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var borderImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "border_icon")
        view.layer.cornerRadius = Self.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()

    private let tapAction: (() -> Void)?

    init(type: Compilation, tapAction: (() -> Void)? = nil) {
        self.tapAction = tapAction
        super.init(frame: .zero)

        titleLabel.text = type.title
        imageView.image = type.image
        setupLayout(isHighlightedBorder: type.isHighlightedBorder)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .white
        self.applyShadow(with: Shadows.standardWideShadow)
        layer.cornerRadius = Self.cornerRadius
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTap)))

    }

    private func setupLayout(isHighlightedBorder: Bool) {
        if isHighlightedBorder {
            self.addSubview(borderImageView)
            borderImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        [titleLabel, imageView].forEach(isHighlightedBorder ?  borderImageView.addSubview : addSubview)

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(isHighlightedBorder ? 3 : 0)
            make.height.equalTo(self.snp.height).multipliedBy(0.8)
        }
        

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageView.snp.bottom).offset(17)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    @objc
    private func onViewTap() {
        tapAction?()
    }
}
