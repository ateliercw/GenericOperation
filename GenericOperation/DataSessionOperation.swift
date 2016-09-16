//
//  DataSessionOperation.swift
//  GenericOperation
//
//  Created by Michael Skiba on 7/29/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import Foundation

private extension AsynchronousOperation.State {
    init(dataTaskState: URLSessionTask.State) {
        switch dataTaskState {
        case .canceling, .completed:
            self = .finished
        case .running:
            self = .executing
        case .suspended:
            self = .ready
        }
    }
}

open class DataSessionOperation<Query: ResultParsing>: AsynchronousOperation {

    fileprivate(set) open var result: Result<Query.ParsedResult>?
    @objc fileprivate var dataTask: URLSessionDataTask?
    fileprivate let query: Query

    public init(query: Query) {
        self.query = query
        super.init()
        self.dataTask = query.urlSession.dataTask(with: query.url, completionHandler: self.taskCompletion)
        addObserver(self, forKeyPath: #keyPath(dataTask.state), options: [.new], context: nil)
    }

    deinit {
        removeObserver(self, forKeyPath: #keyPath(dataTask.state))
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as? DataSessionOperation) == self && keyPath == #keyPath(dataTask.state) {
            if let newValue = change?[.newKey] as? URLSessionTask.State {
                state = AsynchronousOperation.State(dataTaskState: newValue)
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    open override func main() {
        dataTask?.resume()
    }

    open override func cancel() {
        defer {
            super.cancel()
        }
        dataTask?.cancel()
    }

    fileprivate func taskCompletion(_ data: Data?, response: URLResponse?, error: Error?) {
        defer {
            state = .finished
        }
        if !isCancelled {
            result = query.parseResult(data, response: response, error: error)
            dataTask?.cancel()
        }
    }

}
