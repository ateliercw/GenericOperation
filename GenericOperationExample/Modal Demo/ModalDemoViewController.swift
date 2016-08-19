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
        demoView.presentOnceButton.addTarget(self, action: #selector(presentSingleModal(target:)), for: .touchUpInside)
        demoView.presentTwiceButton.addTarget(self, action: #selector(presentTwoModals(target:)), for: .touchUpInside)
        demoView.presentTenTimesButton.addTarget(self, action: #selector(presentThreeModals(target:)), for: .touchUpInside)
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

    @objc func presentSingleModal(target: UIButton) {
        presentModals(count: 1)
    }

    @objc func presentTwoModals(target: UIButton) {
        presentModals(count: 2)
    }

    @objc func presentThreeModals(target: UIButton) {
        presentModals(count: 10)
    }

    func presentModals(count: Int) {
        modalOperations = Array(0..<count).map { _ in
            return ModalPresentationOperation(viewControllerToPresent: ModalDemoPresentedViewController(), delegate: self)
        }
    }
}
