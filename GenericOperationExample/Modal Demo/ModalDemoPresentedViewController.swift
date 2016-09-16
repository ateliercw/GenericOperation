//
//  ModalDemoPresentedViewController.swift
//  GenericOperation
//
//  Created by Michael Skiba on 8/19/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import UIKit
import GenericOperation

class ModalDemoPresentedViewController: UIViewController, Presentable {

    weak open var presentationOperation: AsynchronousOperation?

    var demoPresentedView: ModalDemoPresentedView! {
        return view as? ModalDemoPresentedView
    }

    override func loadView() {
        view = ModalDemoPresentedView()
        demoPresentedView.dismissThisButton.addTarget(self, action: #selector(dismissThis(_:)), for: .touchUpInside)
        demoPresentedView.dismissAllButton.addTarget(self, action: #selector(dismissAll(_:)), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentationOperation?.state = .executing
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presentationOperation?.state = .finished
    }

}

private extension ModalDemoPresentedViewController {

    @objc func dismissThis(_ sender: UIButton) {
        if let presentationDelegate = (presentationOperation as? AnyModalPresentationOperation)?.presentationDelegate {
            dismiss(animated: presentationDelegate.animated,
                    completion: presentationDelegate.completion)
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }

    @objc func dismissAll(_ sender: UIButton) {
        defer {
            dismissThis(sender)
        }
        let presentationDelegate = (presentationOperation as? AnyModalPresentationOperation)?.presentationDelegate
        (presentationDelegate  as? ModalDemoViewController)?.modalOperations = []
    }
}
