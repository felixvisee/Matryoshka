//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Result
import ReactiveCocoa
import Argo
import Matryoshka

public struct GetUser: OperationType, Equatable {
    public var toHTTPRequest = { (id: Int) -> Result<HTTPRequest, NSError> in
        return .success(HTTPRequest(method: .GET, path: "/users/\(id).json"))
    }

    public var toUser = { (response: HTTPResponse) -> Result<User, NSError> in
        return response.json >>- { json in
            return User.decode(json).result
        }
    }

    public var id: Int

    public init(id: Int) {
        self.id = id
    }

    public func execute(execute: HTTPRequest -> SignalProducer<HTTPResponse, NSError>) -> SignalProducer<User, NSError> {
        return SignalProducer(value: id)
            |> tryMap(toHTTPRequest)
            |> map(execute) |> flatten(.Merge)
            |> tryMap(toUser)
    }
}

public func == (lhs: GetUser, rhs: GetUser) -> Bool {
    return lhs.id == rhs.id
}

public struct GetUserFactory: OperationFactoryType {
    public init() {
        
    }

    public func create(input: Int) -> GetUser.Operation {
        return Operation(GetUser(id: input))
    }
}
