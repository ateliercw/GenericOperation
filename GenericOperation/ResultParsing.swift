//
//  ResultParsing.swift
//  GenericOperation
//
//  Created by Michael Skiba on 7/29/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import Foundation

public enum Result<T> {
    case error(Error)
    case success(T)

    public var value: T? {
        switch self {
        case .error:
            return nil
        case let .success(value):
            return value
        }
    }
}

public protocol ResultParsing {
    associatedtype ParsedResult

    func parseResult(data: Data?, response: URLResponse?, error: Error?) -> Result<ParsedResult>

    var url: URL { get }
    var urlSession: URLSession { get }

}
