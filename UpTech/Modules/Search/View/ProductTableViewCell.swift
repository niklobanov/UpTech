//
//  ProductTableViewCell.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import UIKit
import SnapKit

final class ProductTableViewCell: UITableViewCell, Reusable {
    private lazy var productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor(hex: "#636b6f")
        return label
    }()

    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .gray
        label.textColor = UIColor(hex: "#afb5b6")
        return label
    }()

    private lazy var inStockLabel: UILabel = {
        let label = UILabel()
        label.text = "В наличии"
        label.textColor = UIColor(hex: "#76bbb0")
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "81 ₽"
        label.textColor = UIColor(hex: "#76bbb0")
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {

    }


    private func setupLayout() {
        [productImageView, titleLabel, countryLabel, inStockLabel, priceLabel].forEach(addSubview)

        productImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(20)
            make.size.equalTo(CGSize(width: 120, height: 100))
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(20)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        inStockLabel.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(20)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(20)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
