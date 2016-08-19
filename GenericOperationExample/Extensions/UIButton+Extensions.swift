//
//  UIButton+Extensions.swift
//  GenericOperation
//
//  Created by Michael Skiba on 8/10/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String, target: NSObjectProtocol? = nil, action: Selector? = nil) {
        self.init(type: .system)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        setTitle(title, for: .normal)
        if let target = target, let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
}
