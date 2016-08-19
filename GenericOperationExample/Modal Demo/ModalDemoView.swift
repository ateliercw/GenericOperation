//
//  ModalDemoView.swift
//  GenericOperation
//
//  Created by Michael Skiba on 8/19/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import UIKit

class ModalDemoView: UIView {

    let presentOnceButton = UIButton(title: NSLocalizedString("Present Once", comment: "Present one modal"))
    let presentTwiceButton = UIButton(title: NSLocalizedString("Present Twice", comment: "Present two modals in a row"))
    let presentTenTimesButton = UIButton(title: NSLocalizedString("Present Ten Times", comment: "Present ten modals in a row"))


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

private extension ModalDemoView {
    func prepareLayout() {
        let stackView = UIStackView(arrangedSubviews: [presentOnceButton, presentTwiceButton, presentTenTimesButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .vertical
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.layoutMarginsGuide.bottomAnchor),
            ])
    }
}
