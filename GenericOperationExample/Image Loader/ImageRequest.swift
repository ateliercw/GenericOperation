//
//  ImageRequest.swift
//  GenericOperation
//
//  Created by Michael Skiba on 8/11/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import UIKit
import GenericOperation

struct ImageRequest: ResultParsing {
    struct Return {
        let image: UIImage
        let data: Data

        init?(data: Data) {
            guard let image = UIImage(data: data) else {
                return nil
            }
            self.image = image
            self.data = data
        }
    }

    enum Errors: Error {
        case noImage
    }

    typealias ParsedResult = Return
    let url: URL
    let urlSession: URLSession

    init(url: URL, urlSession: URLSession) {
        self.url = url
        self.urlSession = urlSession
    }

    func parseResult(data: Data?, response: URLResponse?, error: Error?) -> Result<ParsedResult> {
        let result: Result<ParsedResult>
        if let error = error {
            result = .error(error)
        }
        else if let data = data.flatMap(Return.init) {
            result = .success(data)
        }
        else {
            result = .error(Errors.noImage)
        }
        return result
    }
}
