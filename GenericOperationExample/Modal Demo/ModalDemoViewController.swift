//
//  ModalDemoViewController.swift
//  GenericOperation
//
//  Created by Michael Skiba on 8/10/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import UIKit
import GenericOperation

class ModalDemoViewController: UIViewController {

    var modalOperations: [Operation] = [] {
        willSet {
            for operation in modalOperations {
                operation.cancel()
            }
        }
        didSet {
            OperationQueue.main.addOperations(modalOperations, waitUntilFinished: false)
        }
    }

    var demoView: ModalDemoView! {
        return view as? ModalDemoView
    }

    override func loadView() {
        view = ModalDemoView()
        demoView.presentOnceButton.addTarget(self, action: #selector(presentSingleModal(_:)), for: .touchUpInside)
        demoView.presentTwiceButton.addTarget(self, action: #selector(presentTwoModals(_:)), for: .touchUpInside)
        demoView.presentTenTimesButton.addTarget(self, action: #selector(presentThreeModals(_:)), for: .touchUpInside)
        edgesForExtendedLayout = []
    }

}

extension ModalDemoViewController: ModalPresentationOperationDelegate {

    var presentationSource: UIViewController? {
        return self
    }

    var animated: Bool {
        return true
    }
    var completion: (() -> Void)? {
        return nil
    }

}

private extension ModalDemoViewController {

    @objc func presentSingleModal(_ target: UIButton) {
        presentModals(1)
    }

    @objc func presentTwoModals(_ target: UIButton) {
        presentModals(2)
    }

    @objc func presentThreeModals(_ target: UIButton) {
        presentModals(10)
    }

    func presentModals(_ count: Int) {
        modalOperations = Array(0..<count).map { _ in
            return ModalPresentationOperation(viewControllerToPresent: ModalDemoPresentedViewController(), delegate: self)
        }
    }
}
