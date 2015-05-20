import XCPlayground

// Continue playground execution indefinitely because we are going to perform
// some real network requests.
XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)

import Dobby
import Result
import ReactiveCocoa
import Matryoshka
import MatryoshkaPlayground

// Create a stub for HTTP requests.
let HTTPOperationStub = Stub<Interaction1<HTTPRequest>, SignalProducer<HTTPResponse, NSError>>()

// Create an operation mock for HTTP requests. Unless the stub defines behavior
// for a specific request, the execution will be forwarded.
struct HTTPOperationMock: OperationType {
    let operation: HTTPOperation

    init(baseURL: NSURL, request: HTTPRequest) {
        operation = HTTPOperation(baseURL: baseURL, request: request)
    }

    func execute(execute: NSURLRequest -> SignalProducer<(NSData, NSURLResponse), NSError>) -> SignalProducer<HTTPResponse, NSError> {
        return invoke(HTTPOperationStub, interaction(value(operation.request))) ?? operation.execute(execute)
    }
}

var configuration = NetworkManager.Configuration()
// Switch from HTTPS (default) to HTTP.
configuration.baseURL = NSURL(string: "http://api.soundcloud.com")!
// Create an operation factory for our HTTP operation mock.
configuration.HTTPOperationFactory = OperationFactory { input in
    return Operation(HTTPOperationMock(baseURL: input.baseURL, request: input.request))
}

let networkManager = NetworkManager(configuration: configuration)

// Get the track with id 177965394, then the user that uploaded it.
let real = GetTrack(id: 177965394).execute(networkManager.execute)
    |> map { track in track.userId }
    |> perform(.Merge, GetUserFactory(), networkManager.execute)
    |> first

// Oh yeah, that was me.
real?.value?.username

let data = "{ \"id\": -1, \"username\": \"nobody\" }".dataUsingEncoding(NSUTF8StringEncoding)
// Stub any future HTTP requests that tries to load the same user again and
// return a fake user instead.
behave(HTTPOperationStub, interaction(filter { request in
    return startsWith(request.path, "/users/\(real!.value!.id)")
}), SignalProducer(value: HTTPResponse(statusCode: .OK, data: data)))

// Again, get the track with id 177965394, then the user that uploaded it.
let fake = GetTrack(id: 177965394).execute(networkManager.execute)
    |> map { track in track.userId }
    |> perform(.Merge, GetUserFactory(), networkManager.execute)
    |> first

// Call me maybe.
fake?.value?.username
