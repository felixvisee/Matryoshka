//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import ReactiveCocoa

/// A closure-based operation.
public struct Operation<ExecuteInput, ExecuteOutput, ExecuteError: ErrorType, Output, Error: ErrorType>: OperationType {
    private let executeClosure: (ExecuteInput -> SignalProducer<ExecuteOutput, ExecuteError>) -> SignalProducer<Output, Error>

    /// Creates a closure-based operation with the given closure.
    public init(_ execute: (ExecuteInput -> SignalProducer<ExecuteOutput, ExecuteError>) -> SignalProducer<Output, Error>) {
        executeClosure = execute
    }

    public func execute(execute: ExecuteInput -> SignalProducer<ExecuteOutput, ExecuteError>) -> SignalProducer<Output, Error> {
        return executeClosure(execute)
    }
}

extension Operation {
    /// Creates a closure-based operation that wraps the given operation.
    public init<O: OperationType where O.ExecuteInputType == ExecuteInput, O.ExecuteOutputType == ExecuteOutput, O.ExecuteErrorType == ExecuteError, O.OutputType == Output, O.ErrorType == Error>(_ operation: O) {
        self.init({ execute in
            return operation.execute(execute)
        })
    }
}
