//: Playground - noun: a place where people can play

import UIKit
import GenericOperation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

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

    enum Errors: ErrorProtocol {
        case noImage
    }

    typealias ParsedResult = Return
    let url: URL
    let urlSession: URLSession

    init(url: URL, urlSession: URLSession) {
        self.url = url
        self.urlSession = urlSession
    }

    func parseResult(data: Data?, response: URLResponse?, error: NSError?) -> Result<ParsedResult> {
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

let imageURL = URL(string: "http://placekitten.com/200/300")!

let session = URLSession(configuration: URLSessionConfiguration.default)

let imageLoader = ImageRequest.init(url: imageURL, urlSession: session)

let imageOperation = DataSessionOperation(query: imageLoader)

let followUp = FollowUpOperation(parentOperation: imageOperation) { parent in
    guard let result = parent.result else {
        return
    }
    switch result {
    case .error:
        break
    case .success(let image):
        image
    }
}

OperationQueue.main.addOperation(imageOperation)
OperationQueue.main.addOperation(followUp)
