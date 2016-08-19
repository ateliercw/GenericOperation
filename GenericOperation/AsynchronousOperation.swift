//
//  AsynchronousOperation.swift
//  GenericOperation
//
//  Created by Michael Skiba on 7/29/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import Foundation

// Adapted from code in https://github.com/shrutic/NSOperation-Swift
public class AsynchronousOperation: Operation {

    public enum State {
        case Ready, Executing, Finished

        fileprivate var keyPath: String {
            let keyPath: String
            switch self {
            case .Ready: keyPath = #keyPath(Operation.isReady)
            case .Executing: keyPath = #keyPath(Operation.isExecuting)
            case .Finished: keyPath = #keyPath(Operation.isFinished)
            }
            return keyPath
        }
    }

    public var state = State.Ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }

        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    override public var isReady: Bool {
        return super.isReady && self.state == .Ready
    }

    override public var isExecuting: Bool {
        return self.state == .Executing
    }

    override public var isFinished: Bool {
        return self.state == .Finished
    }

    override public var isAsynchronous: Bool {
        return true
    }

    override public func start() {
        if self.isCancelled {
            state = .Finished
        }
        else {
            self.main() // This should set self.state = .Finished when done with execution
            state = .Executing
        }
    }
}
