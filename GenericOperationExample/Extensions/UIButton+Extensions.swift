//
//  UIButton+Extensions.swift
//  GenericOperation
//
//  Created by Michael Skiba on 8/10/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String, target: NSObjectProtocol, action: Selector) {
        self.init(type: .system)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleBody)
        setTitle(title, for: .normal)
        addTarget(target, action: action, for: .touchUpInside)
    }
}
