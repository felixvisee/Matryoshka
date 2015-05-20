//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Foundation

public struct HTTPRequest: Equatable {
    public var method: HTTPMethod
    public var path: String
    public var parameters: [String: AnyObject]?
    public var parameterEncoding: HTTPParameterEncoding
    public var headerFields: [String: String]?

    public init(method: HTTPMethod, path: String, parameters: [String: AnyObject]? = nil, parameterEncoding: HTTPParameterEncoding = .URL, headerFields: [String: String]? = nil) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
        self.headerFields = headerFields
    }
}

private func == (lhs: [String: AnyObject]?, rhs: [String: AnyObject]?) -> Bool {
    switch (lhs, rhs) {
    case let (.Some(lhs), .Some(rhs)):
        return (lhs as NSDictionary).isEqual(rhs as NSDictionary)
    case (nil, nil):
        return true
    default:
        return false
    }
}

public func == (lhs: HTTPRequest, rhs: HTTPRequest) -> Bool {
    return lhs.method == rhs.method
        && lhs.path == rhs.path
        && lhs.parameters == rhs.parameters
        && lhs.parameterEncoding == rhs.parameterEncoding
        && lhs.headerFields == rhs.headerFields
}

extension HTTPRequest: Printable {
    public var description: String {
        return "HTTPRequest(method: \(method), path: \(path), parameters: \(parameters), parameterEncoding: \(parameterEncoding), headerFields: \(headerFields))"
    }
}
