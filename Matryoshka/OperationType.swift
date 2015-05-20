//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import ReactiveCocoa

/// An operation type that delegates the execution of its task to a function.
public protocol OperationType {
    typealias ExecuteInputType
    typealias ExecuteOutputType
    typealias ExecuteErrorType: ReactiveCocoa.ErrorType

    typealias OutputType
    typealias ErrorType: ReactiveCocoa.ErrorType

    typealias Operation = Matryoshka.Operation<ExecuteInputType, ExecuteOutputType, ExecuteErrorType, OutputType, ErrorType>

    /// Creates a SignalProducer that, when started, will execute the task using
    /// the given function, then forward the results upon the produced Signal.
    func execute(execute: ExecuteInputType -> SignalProducer<ExecuteOutputType, ExecuteErrorType>) -> SignalProducer<OutputType, ErrorType>
}

// MARK: - Basics

/// OperationType.execute() as a free function.
public func execute<O: OperationType>(operation: O) -> (O.ExecuteInputType -> SignalProducer<O.ExecuteOutputType, O.ExecuteErrorType>) -> SignalProducer<O.OutputType, O.ErrorType> {
    return { execute in
        return operation.execute(execute)
    }
}

// MARK: - Transformer

/// Maps an input value to an operation which is performed with the given
/// execution function.
public func perform<T, O: OperationType>(create: T -> O, execute: O.ExecuteInputType -> SignalProducer<O.ExecuteOutputType, O.ExecuteErrorType>) -> T -> SignalProducer<O.OutputType, O.ErrorType> {
    return { input in
        return create(input).execute(execute)
    }
}

// MARK: - Operator

/// Maps each input value to an operation which is performed with the given
/// execution function, then flattens the resulting producers (into a single
/// producer of values), according to the semantics of the given strategy.
///
/// Equivalent to: `flatMap(strategy, perform(create, execute))`.
public func perform<T, O: OperationType>(strategy: FlattenStrategy, create: T -> O, execute: O.ExecuteInputType -> SignalProducer<O.ExecuteOutputType, O.ExecuteErrorType>) -> SignalProducer<T, O.ErrorType> -> SignalProducer<O.OutputType, O.ErrorType> {
    return { producer in
        return producer |> map(perform(create, execute)) |> flatten(strategy)
    }
}
