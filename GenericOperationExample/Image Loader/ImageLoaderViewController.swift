//
//  ImageLoaderViewController.swift
//  GenericOperation
//
//  Created by Michael Skiba on 8/10/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import UIKit
import GenericOperation

final class ImageLoaderViewController: UIViewController {

    private enum ViewModel {
        case status(String)
        case image(UIImage)
        case none
    }

    let imageView = UIImageView()
    let statusLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let imageLoadingQueue: OperationQueue = { imageLoadingQueue in
        imageLoadingQueue.qualityOfService = .userInitiated
        return imageLoadingQueue
    }(OperationQueue())
    var updateOperation: Operation? {
        willSet {
            updateOperation?.cancel()
        }
    }

    private func configure(with viewModel: ViewModel) {
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

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        activityIndicator.hidesWhenStopped = true
        let reloadButton = UIButton(title: NSLocalizedString("Reload Image", comment: "Button title for reloading the random image"),
                                    target: self,
                                    action: #selector(reloadImage))
        let stackView = UIStackView(arrangedSubviews: [reloadButton, imageView, statusLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        view.addSubview(stackView)
        imageView.addSubview(activityIndicator)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomLayoutGuide.topAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            ])

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageLoadingQueue.cancelAllOperations()
        OperationQueue.main.cancelAllOperations()
    }
}

private extension ImageLoaderViewController {

    @objc func reloadImage() {
        imageLoadingQueue.cancelAllOperations()
        guard let imageURL = URL(string: "https://unsplash.it/400?random") else {
            self.configure(with: .status(NSLocalizedString("Couldn't create url", comment: "failed to create URL status message")))
            return
        }
        self.configure(with: .none)
        activityIndicator.startAnimating()

        let imageLoader = ImageRequest.init(url: imageURL, urlSession: session)
        let imageOperation = DataSessionOperation(query: imageLoader)

        let update = FollowUpOperation(parentOperation: imageOperation) { [weak self] parent in
            self?.activityIndicator.stopAnimating()
            guard let result = parent.result else {
                return
            }
            switch result {
            case .error:
                self?.configure(with: .status(NSLocalizedString("Failed to load image", comment: "Failed to load image error text")))
            case .success(let image):
                self?.configure(with: .image(image.image))
            }
        }
        updateOperation = update
        OperationQueue.main.addOperation(update)
        imageLoadingQueue.addOperation(imageOperation)
    }

}
