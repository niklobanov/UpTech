//
//  HomeViewController.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import UIKit

final class HomeViewController: UIViewController {
    private lazy var allergyView = CompilationView(type: .allergy)
    private lazy var covidView = CompilationView(type: .covid)
    private lazy var diabetesView = CompilationView(type: .diabetes)
    private lazy var efficiencyView = CompilationView(type: .efficiency) { [weak self] in
        self?.navigationController?.pushViewController(ProductsFlow.makeProductsList(), animated: true)
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Подборки"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private var blockWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let insets: CGFloat = 14 * 2 + 6
        return (screenWidth - insets) / 2
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        [titleLabel, allergyView, covidView, diabetesView, efficiencyView].forEach(view.addSubview)
        setupConstraints()
        self.view = view
    }


    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(14)
        }

        allergyView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.height.equalTo(blockWidth)
            make.leading.equalToSuperview().inset(14)
        }

        covidView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.height.equalTo(blockWidth)
            make.trailing.equalToSuperview().inset(14)
        }

        diabetesView.snp.makeConstraints { make in
            make.top.equalTo(allergyView.snp.bottom).offset(6)
            make.width.height.equalTo(blockWidth)
            make.leading.equalToSuperview().inset(14)
        }

        efficiencyView.snp.makeConstraints { make in
            make.top.equalTo(allergyView.snp.bottom).offset(6)
            make.width.height.equalTo(blockWidth)
            make.trailing.equalToSuperview().inset(14)
        }
    }
}

