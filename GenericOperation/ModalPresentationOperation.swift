//
//  ModalPresentationOperation.swift
//  GenericOperation
//
//  Created by Michael Skiba on 8/10/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import Foundation

public protocol Presentable: AnyObject {

    weak var presentationOperation: AsynchronousOperation? { get set }

}

public protocol ModalPresentationOperationDelegate: AnyObject {

    var presentationSource: UIViewController? { get }
    var animated: Bool { get }
    var completion: (() -> Void)? { get }

}

public protocol AnyModalPresentationOperation {

    weak var presentationDelegate: ModalPresentationOperationDelegate? { get }

}

public class ModalPresentationOperation<Presented: UIViewController>: AsynchronousOperation, AnyModalPresentationOperation where Presented: Presentable {

    public weak var presentationDelegate: ModalPresentationOperationDelegate?
    public var viewControllerToPresent: Presented

    public init(viewControllerToPresent: Presented, delegate: ModalPresentationOperationDelegate? = nil) {
        self.viewControllerToPresent = viewControllerToPresent
        self.presentationDelegate = delegate
        super.init()
        viewControllerToPresent.presentationOperation = self
    }

    override public func main() {
        checkForPresentation()
    }

    override public func cancel() {
        defer {
            super.cancel()
        }
        if viewControllerToPresent.presentingViewController != nil {
            let animated = presentationDelegate?.animated ?? true
            viewControllerToPresent.dismiss(animated: animated, completion: nil)
        }
    }

}

private extension ModalPresentationOperation {

    func checkForPresentation() {
        guard let presenter = presentationDelegate?.presentationSource else {
            cancel()
            return
        }
        if (presenter.presentedViewController?.isBeingPresented ?? presenter.isBeingPresented) || (presenter.presentedViewController?.isBeingDismissed ?? presenter.isBeingDismissed) {
            waitForPresentationToFinish()
        }
        else {
            finishPresentation()
        }
    }

    func waitForPresentationToFinish() {
        let wait = DispatchTime.now() + DispatchTimeInterval.microseconds(16667)
        DispatchQueue.main.asyncAfter(deadline: wait) { [weak self] in
            self?.checkForPresentation()
        }
    }

    func finishPresentation() {
        guard let presenter = presentationDelegate?.presentationSource,
            let animated = presentationDelegate?.animated,
            isCancelled == false else {
                cancel()
                return
        }
        presenter.present(viewControllerToPresent,
                          animated: animated,
                          completion: presentationDelegate?.completion)
    }

}
