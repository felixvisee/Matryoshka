//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Foundation

import Result
import Argo

public struct HTTPResponse: Equatable {
    public var statusCode: HTTPStatusCode
    public var data: NSData?

    public var json: Result<JSON, NSError> {
        return try { error in
            return NSJSONSerialization.JSONObjectWithData(self.data!, options: NSJSONReadingOptions(0), error: error)
        }.map(JSON.parse)
    }

    public init(statusCode: HTTPStatusCode, data: NSData? = nil) {
        self.statusCode = statusCode
        self.data = data
    }
}

public func == (lhs: HTTPResponse, rhs: HTTPResponse) -> Bool {
    return lhs.statusCode == rhs.statusCode && lhs.data == rhs.data
}

extension HTTPResponse: Printable {
    public var description: String {
        return "HTTPResponse(statusCode: \(statusCode), data: \(data))"
    }
}
