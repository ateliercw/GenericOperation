//
//  ModalDemoPresentedView.swift
//  GenericOperation
//
//  Created by Michael Skiba on 8/19/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import UIKit

class ModalDemoPresentedView: UIView {

    let dismissThisButton = UIButton(title: NSLocalizedString("Dismiss This", comment: "Dismiss this modal"))
    let dismissAllButton = UIButton(title: NSLocalizedString("Dismiss All", comment: "Dismiss all of the modals"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        prepareLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareLayout()
    }

}

private extension ModalDemoPresentedView {
    func prepareLayout() {
        let stackView = UIStackView(arrangedSubviews: [dismissThisButton, dismissAllButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .vertical
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.layoutMarginsGuide.bottomAnchor),
            ])
    }
}
