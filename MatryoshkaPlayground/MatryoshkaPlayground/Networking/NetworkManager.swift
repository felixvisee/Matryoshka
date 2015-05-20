//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Foundation

import Result
import ReactiveCocoa
import Argo
import Matryoshka

public let NetworkManagerErrorDomain = "NetworkManagerErrorDomain"
public enum NetworkManagerErrorCode: Int {
    case InvalidResponse = 1
}

public class NetworkManager {
    public struct Configuration {
        public struct Credentials {
            public var id: String = "a4ad8d73d0bd0c04008d88b35e78fbce"
            public var secret: String?

            public init(id: String? = nil, secret: String? = nil) {
                if let id = id {
                    self.id = id
                }

                self.secret = secret
            }
        }

        public var baseURL = NSURL(string: "https://api.soundcloud.com")!
        public var URLSession = NSURLSession.sharedSession()
        public var URLOperationFactory = OperationFactory(MatryoshkaPlayground.URLOperationFactory())
        public var HTTPOperationFactory = OperationFactory(MatryoshkaPlayground.HTTPOperationFactory())

        public var credentials: Credentials

        public init(credentials: Credentials = Credentials()) {
            self.credentials = credentials
        }
    }

    public let configuration: Configuration

    public init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
    }

    public func execute(request: HTTPRequest) -> SignalProducer<HTTPResponse, NSError> {
        return SignalProducer(value: (baseURL: configuration.baseURL, request: request))
            |> map { (baseURL, var request) in
                var parameters = request.parameters ?? [:]
                parameters["client_id"] = self.configuration.credentials.id
                parameters["client_secret"] = self.configuration.credentials.secret
                request.parameters = parameters
                return (baseURL, request)
            }
            |> perform(.Merge, configuration.HTTPOperationFactory) { request in
                return SignalProducer(value: request)
                    |> perform(.Merge, self.configuration.URLOperationFactory, self.configuration.URLSession.rac_dataWithRequest)
            }
            |> tryMap { response in
                let error = { NSError(domain: NetworkManagerErrorDomain, code: NetworkManagerErrorCode.InvalidResponse.rawValue, userInfo: nil) }
                return Result(response.statusCode == .OK ? response : nil, failWith: error())
            }
    }
}
