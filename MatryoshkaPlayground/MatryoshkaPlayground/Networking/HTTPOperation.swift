//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Result
import ReactiveCocoa
import Matryoshka

public let HTTPOperationErrorDomain = "HTTPOperationErrorDomain"
public enum HTTPOperationErrorCode: Int {
    case InvalidResponse = 1
}

public struct HTTPOperation: OperationType {
    public var toURLRequest = { (baseURL: NSURL, request: HTTPRequest) -> Result<NSURLRequest, NSError> in
        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: request.path, relativeToURL: baseURL)!)
        mutableURLRequest.HTTPMethod = request.method.rawValue
        mutableURLRequest.allHTTPHeaderFields = request.headerFields

        let (URLRequest, error) = request.parameterEncoding.encode(mutableURLRequest, parameters: request.parameters)
        if let error = error {
            return .failure(error)
        }

        return .success(URLRequest)
    }

    public var toHTTPResponse = { (data: NSData, response: NSURLResponse) -> Result<HTTPResponse, NSError> in
        let error = { NSError(domain: HTTPOperationErrorDomain, code: HTTPOperationErrorCode.InvalidResponse.rawValue, userInfo: nil) }
        return Result((response as? NSHTTPURLResponse)?.statusCode, failWith: error()).map { statusCode in
            return HTTPResponse(statusCode: HTTPStatusCode(rawValue: statusCode), data: data)
        }
    }

    public var baseURL: NSURL
    public var request: HTTPRequest

    public init(baseURL: NSURL, request: HTTPRequest) {
        self.baseURL = baseURL
        self.request = request
    }

    public func execute(execute: NSURLRequest -> SignalProducer<(NSData, NSURLResponse), NSError>) -> SignalProducer<HTTPResponse, NSError> {
        return SignalProducer(value: (baseURL: baseURL, request: request))
            |> tryMap(toURLRequest)
            |> map(execute) |> flatten(.Merge)
            |> tryMap(toHTTPResponse)
    }
}

public struct HTTPOperationFactory: OperationFactoryType {
    public func create(input: (baseURL: NSURL, request: HTTPRequest)) -> HTTPOperation.Operation {
        return Operation(HTTPOperation(baseURL: input.baseURL, request: input.request))
    }
}
