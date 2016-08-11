//
//  ModalPresentationOperation.swift
//  GenericOperation
//
//  Created by Michael Skiba on 8/10/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import Foundation

protocol Presentable {

    weak var operation: AsynchronousOperation { get, set }

}

protocol ModalPresentationOperationDelegate: AnyObject {

    var presentationSource: UIViewController? { get }
    var animated: Bool { get }
    var completion: (() -> Void)? { get }

}

class ModalPresentationOperation<Presented: UIViewController, Presentable>: AsynchronousOperation {

    weak var presentationDelegate: ModalPresentationOperationDelegate?
    var viewControllerToPresent: Presented

    init(viewControllerToPresent: Presented, delegate: ModalPresentationOperationDelegate? = nil) {
        self.viewControllerToPresent = viewControllerToPresent
        self.presentationDelegate = delegate
        viewControllerToPresent.operation = self
    }

    override func main() {
        guard let presenter = presentationDelegate?.presentationSource,
            let animated = presentationDelegate?.animated else {
                cancel()
                return
        }
        presenter.present(viewControllerToPresent,
                          animated: animated,
                          completion: presentationDelegate?.completion)
    }

    override func cancel() {
        super.cancel()
        if viewControllerToPresent.isBeingPresented {
            let animated = presentationDelegate?.animated ?? true
            viewControllerToPresent.dismiss(animated: animated, completion: nil)
        }
    }

}
