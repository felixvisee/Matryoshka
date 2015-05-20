//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Result
import ReactiveCocoa
import Argo
import Matryoshka

public struct GetTrack: OperationType, Equatable {
    public var toHTTPRequest = { (id: Int) -> Result<HTTPRequest, NSError> in
        return .success(HTTPRequest(method: .GET, path: "/tracks/\(id).json"))
    }

    public var toTrack = { (response: HTTPResponse) -> Result<Track, NSError> in
        return response.json >>- { json in
            return Track.decode(json).result
        }
    }

    public var id: Int

    public init(id: Int) {
        self.id = id
    }

    public func execute(execute: HTTPRequest -> SignalProducer<HTTPResponse, NSError>) -> SignalProducer<Track, NSError> {
        return SignalProducer(value: id)
            |> tryMap(toHTTPRequest)
            |> map(execute) |> flatten(.Merge)
            |> tryMap(toTrack)
    }
}

public func == (lhs: GetTrack, rhs: GetTrack) -> Bool {
    return lhs.id == rhs.id
}

public struct GetTrackFactory: OperationFactoryType {
    public init() {
        
    }

    public func create(input: Int) -> GetTrack.Operation {
        return Operation(GetTrack(id: input))
    }
}
