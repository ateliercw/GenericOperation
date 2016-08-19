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

    weak public var presentationOperation: AsynchronousOperation?

    var demoPresentedView: ModalDemoPresentedView! {
        return view as? ModalDemoPresentedView
    }

    override func loadView() {
        view = ModalDemoPresentedView()
        demoPresentedView.dismissThisButton.addTarget(self, action: #selector(dismissThis(sender:)), for: .touchUpInside)
        demoPresentedView.dismissAllButton.addTarget(self, action: #selector(dismissAll(sender:)), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        presentationOperation?.state = .Executing
    }

    override func viewDidDisappear(_ animated: Bool) {
        presentationOperation?.state = .Finished
    }

}

private extension ModalDemoPresentedViewController {

    @objc func dismissThis(sender: UIButton) {
        if let presentationDelegate = (presentationOperation as? AnyModalPresentationOperation)?.presentationDelegate {
            dismiss(animated: presentationDelegate.animated,
                    completion: presentationDelegate.completion)
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }

    @objc func dismissAll(sender: UIButton) {
        defer {
            dismissThis(sender: sender)
        }
        let presentationDelegate = (presentationOperation as? AnyModalPresentationOperation)?.presentationDelegate
        (presentationDelegate  as? ModalDemoViewController)?.modalOperations = []
    }
}
