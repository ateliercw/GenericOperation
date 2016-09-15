//
//  ImageLoaderView.swift
//  GenericOperation
//
//  Created by Michael Skiba on 8/11/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import UIKit

final class ImageLoaderView: UIView {

    let reloadButton = UIButton(title: NSLocalizedString("Reload Image", comment: "Button title for reloading the random image"))
    fileprivate let imageView = UIImageView()
    fileprivate let statusLabel = UILabel()
    let activityIndicator: UIActivityIndicatorView = { activityIndicator in
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }(UIActivityIndicatorView(activityIndicatorStyle: .gray))

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        prepareLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareLayout()
    }

    func configure(with viewModel: ViewModel) {
        activityIndicator.stopAnimating()
        let statusText: String?
        var image: UIImage?
        switch viewModel {
        case .image(let loadedImage):
            image = loadedImage
            statusText = nil
        case .status(let status):
            statusText = status
            image = nil
        case .none:
            statusText = nil
            image = nil
        }
        statusLabel.text = statusText
        statusLabel.isHidden = (statusText ?? "").isEmpty
        imageView.image = image
    }

    enum ViewModel {
        case status(String)
        case image(UIImage)
        case none
    }

    fileprivate func prepareLayout() {
        let stackView = UIStackView(arrangedSubviews: [reloadButton, imageView, statusLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        addSubview(stackView)
        imageView.addSubview(activityIndicator)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            ])
    }
}
