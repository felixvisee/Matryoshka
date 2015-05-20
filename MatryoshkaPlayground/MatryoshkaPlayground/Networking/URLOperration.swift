//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Result
import ReactiveCocoa
import Matryoshka

public struct URLOperation: OperationType {
    public var URLRequest: NSURLRequest

    public init(URLRequest: NSURLRequest) {
        self.URLRequest = URLRequest
    }

    public func execute(execute: NSURLRequest -> SignalProducer<(NSData, NSURLResponse), NSError>) -> SignalProducer<(NSData, NSURLResponse), NSError> {
        return execute(URLRequest)
    }
}

public struct URLOperationFactory: OperationFactoryType {
    public func create(input: NSURLRequest) -> URLOperation.Operation {
        return Operation(URLOperation(URLRequest: input))
    }
}
