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
            self = .Finished
        case .running:
            self = .Executing
        case .suspended:
            self = .Ready
        }
    }
}

public class DataSessionOperation<Query: ResultParsing>: AsynchronousOperation {

    private(set) public var result: Result<Query.ParsedResult>?
    @objc private var dataTask: URLSessionDataTask?
    private let query: Query

    public init(query: Query) {
        self.query = query
        super.init()
        self.dataTask = query.urlSession.dataTask(with: query.url, completionHandler: self.taskCompletion)
        addObserver(self, forKeyPath: #keyPath(dataTask.state), options: [.new], context: nil)
    }

    deinit {
        removeObserver(self, forKeyPath: #keyPath(dataTask.state))
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as? DataSessionOperation) == self && keyPath == #keyPath(dataTask.state) {
            if let newValue = change?[.newKey] as? URLSessionTask.State {
                state = AsynchronousOperation.State(dataTaskState: newValue)
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    public override func main() {
        dataTask?.resume()
    }

    public override func cancel() {
        defer {
            super.cancel()
        }
        dataTask?.cancel()
    }

    override public var isFinished: Bool {
        return super.isFinished
    }

    private func taskCompletion(data: Data?, response: URLResponse?, error: Error?) {
        defer {
            state = .Finished
        }
        if !isCancelled {
            result = query.parseResult(data: data, response: response, error: error)
            dataTask?.cancel()
        }
    }

}
