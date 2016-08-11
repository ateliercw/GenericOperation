//
//  MainViewController.swift
//  GenericOperationExample
//
//  Created by Michael Skiba on 8/10/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    override func loadView() {
        self.view = UIView()
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [
            UIButton(title: NSLocalizedString("Image Loading", comment: "image loader button title"),
                     target: self, action: #selector(showImageLoader)),
            UIButton(title: NSLocalizedString("Modal Operations", comment: "Modal operations button title"),
                     target: self, action: #selector(showToastDemo)),
            ])
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomLayoutGuide.bottomAnchor),
            ])
    }

}

private extension MainViewController {

    @objc func showImageLoader() {
        navigationController?.pushViewController(ImageLoaderViewController(), animated: true)
    }

    @objc func showToastDemo() {
        navigationController?.pushViewController(ModalDemoViewController(), animated: true)
    }

}
