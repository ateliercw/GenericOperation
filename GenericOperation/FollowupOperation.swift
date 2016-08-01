//
//  FollowupOperation.swift
//  GenericOperation
//
//  Created by Michael Skiba on 7/29/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import Foundation

public class FollowUpOperation<ParentOperation: Operation>: AsynchronousOperation {

    public typealias FollowUpAction = (ParentOperation) -> ()
    public let parentOperation: ParentOperation
    public let followUpAction: FollowUpAction

    public init(parentOperation: ParentOperation, followUpAction: FollowUpAction) {
        self.parentOperation = parentOperation
        self.followUpAction = followUpAction
        super.init()
        addDependency(parentOperation)
    }

    public override func main() {
        defer {
            state = .Finished
        }
        if !isCancelled {
            followUpAction(parentOperation)
        }
    }

}
