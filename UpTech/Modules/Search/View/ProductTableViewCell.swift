//
//  ProductTableViewCell.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import UIKit
import SnapKit
import Nuke

final class ProductTableViewCell: UITableViewCell, ReusableView {
    private lazy var productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "test_icon")
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.uptechFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(hex: "#343b40")
        label.numberOfLines = 0
        return label
    }()

    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.uptechFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.textColor = UIColor(hex: "#afb5b6")
        return label
    }()

    private lazy var inStockLabel: UILabel = {
        let label = UILabel()
        label.text = "В наличии"
        label.font = UIFont.uptechFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#76bbb0")
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#c82667")
        return label
    }()

    private lazy var bageButton: UIButton = {
        let button = UIButton()
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.layer.cornerRadius = 14
        button.backgroundColor = UIColor(red: 0.48, green: 0.45, blue: 0.90, alpha: 1)
        button.titleLabel?.font = UIFont.uptechFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Дешёвый", for: .normal)
        button.contentEdgeInsets = .init(top: 8, left: 10, bottom: 8, right: 10)
        return button
    }()

    private lazy var analogueLabel: MarginsLabel = {
        let label = MarginsLabel()
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 14
        label.font = UIFont.uptechFont(ofSize: 14)
        label.backgroundColor = UIColor(hex: "#feedd8")
        label.textColor = UIColor(hex: "#d2a071")
        return label
    }()

    private lazy var bottomSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#e5e6e6")
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func setup(response: ProductResponse) {
        titleLabel.text = response.name
        countryLabel.text = response.country
        let randomPrice = Int.random(in: 100...1000)
        if let price = Int(response.price) {
            priceLabel.text = "\(price) ₽"
        } else {
            priceLabel.text = "\(randomPrice) ₽"
        }
        if let count = response.analogueIDs?.count {
            let randomAnalogue = Int.random(in: 100...randomPrice)
            let analogeTitle = count == 1 ? "аналог" : "аналога"
            analogueLabel.text = "\(count) \(analogeTitle) от \(randomAnalogue) ₽"
            analogueLabel.isHidden = count == 0
        }

        setupBadge(product: response)
        if let path = response.imageURL, let url = URL(string: path) {
            productImageView.load(url: url)
        } else {
            productImageView.image = UIImage(named: "test_icon")
        }
    }

    func setupBadge(product: ProductResponse) {
        guard
            let effective = product.isEffective,
            let cheap = product.isCheapest,
            let safe = product.isTrustworthy
        else {
            bageButton.isHidden = true
            return
        }

        let badge = ProductBadge(isEffective: effective, isCheapest: cheap, isSafe: safe)
        bageButton.isHidden = badge == .none
        bageButton.setTitle(badge.directTitle, for: .normal)
    }

    private func setupLayout() {
        [
            productImageView,
            titleLabel,
            countryLabel,
            inStockLabel,
            priceLabel,
            analogueLabel,
            bottomSeperatorView,
            bageButton
        ].forEach(contentView.addSubview)

        productImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 120, height: 100))
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        inStockLabel.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(3)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(inStockLabel.snp.bottom).offset(5)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        bageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview()
        }

        analogueLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(12)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
            make.bottom.equalToSuperview().inset(20)
        }

        bottomSeperatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(1)
        }
    }
}
