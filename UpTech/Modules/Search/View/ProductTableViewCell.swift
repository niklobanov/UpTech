//
//  ProductTableViewCell.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import UIKit
import SnapKit

final class ProductTableViewCell: UITableViewCell, ReusableView {
    private lazy var productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "test_icon")
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor(hex: "#343b40")
        label.numberOfLines = 0
        return label
    }()

    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        label.textColor = UIColor(hex: "#afb5b6")
        return label
    }()

    private lazy var inStockLabel: UILabel = {
        let label = UILabel()
        label.text = "В наличии"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hex: "#76bbb0")
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#c82667")
        return label
    }()

    private lazy var analogueLabel: MarginsLabel = {
        let label = MarginsLabel()
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 14
        label.font = UIFont.systemFont(ofSize: 14)
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
            analogueLabel.text = "\(count) аналога от \(randomAnalogue) ₽"
            analogueLabel.isHidden = count == 0
        }

    }

    private func setupLayout() {
        [productImageView, titleLabel, countryLabel, inStockLabel, priceLabel, analogueLabel, bottomSeperatorView].forEach(contentView.addSubview)

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
