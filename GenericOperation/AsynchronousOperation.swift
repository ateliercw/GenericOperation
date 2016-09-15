//
//  AsynchronousOperation.swift
//  GenericOperation
//
//  Created by Michael Skiba on 7/29/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import Foundation

// Adapted from code in https://github.com/shrutic/NSOperation-Swift
open class AsynchronousOperation: Operation {

    public enum State {
        case ready, executing, finished

        fileprivate var keyPath: String {
            let keyPath: String
            switch self {
            case .ready: keyPath = #keyPath(Operation.isReady)
            case .executing: keyPath = #keyPath(Operation.isExecuting)
            case .finished: keyPath = #keyPath(Operation.isFinished)
            }
            return keyPath
        }
    }

    open var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }

        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    override open var isReady: Bool {
        return super.isReady && (self.state == .ready)
    }

    override open var isExecuting: Bool {
        return self.state == .executing
    }

    override open var isFinished: Bool {
        return self.state == .finished
    }

    override open var isAsynchronous: Bool {
        return true
    }

    override open func start() {
        if self.isCancelled {
            state = .finished
        }
        else {
            self.main() // This should set self.state = .Finished when done with execution
            state = .executing
        }
    }
}
