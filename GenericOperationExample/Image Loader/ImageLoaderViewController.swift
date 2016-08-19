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

    var imageLoaderView: ImageLoaderView! {
        return self.view as? ImageLoaderView
    }

    override func loadView() {
        view = ImageLoaderView()
        imageLoaderView.reloadButton.addTarget(self, action: #selector(reloadImage), for: .touchUpInside)
        edgesForExtendedLayout = []
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
            imageLoaderView.configure(with: .status(NSLocalizedString("Couldn't create url", comment: "failed to create URL status message")))
            return
        }
        imageLoaderView.configure(with: .none)
        imageLoaderView.activityIndicator.startAnimating()

        let imageLoader = ImageRequest.init(url: imageURL, urlSession: session)
        let imageOperation = DataSessionOperation(query: imageLoader)

        let update = FollowUpOperation(parentOperation: imageOperation) { [weak self] parent in
            self?.imageLoaderView.activityIndicator.stopAnimating()
            guard let result = parent.result else {
                return
            }
            switch result {
            case .error:
                self?.imageLoaderView.configure(with: .status(NSLocalizedString("Failed to load image", comment: "Failed to load image error text")))
            case .success(let image):
                self?.imageLoaderView.configure(with: .image(image.image))
            }
        }
        updateOperation = update
        OperationQueue.main.addOperation(update)
        imageLoadingQueue.addOperation(imageOperation)
    }

}
