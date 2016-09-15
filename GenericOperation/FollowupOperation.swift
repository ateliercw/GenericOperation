//
//  FollowupOperation.swift
//  GenericOperation
//
//  Created by Michael Skiba on 7/29/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import Foundation

open class FollowUpOperation<ParentOperation: Operation>: AsynchronousOperation {

    public typealias FollowUpAction = (ParentOperation) -> ()
    open let parentOperation: ParentOperation
    open let followUpAction: FollowUpAction

    public init(parentOperation: ParentOperation, followUpAction: @escaping FollowUpAction) {
        self.parentOperation = parentOperation
        self.followUpAction = followUpAction
        super.init()
        addDependency(parentOperation)
    }

    open override func main() {
        defer {
            state = .finished
        }
        if !isCancelled && !parentOperation.isCancelled {
            followUpAction(parentOperation)
        }
    }

}
