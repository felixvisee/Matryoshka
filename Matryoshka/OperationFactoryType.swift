//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import ReactiveCocoa

/// An operation factory type that creates operations for a specific input type.
public protocol OperationFactoryType {
    typealias InputType
    typealias OperationType: Matryoshka.OperationType

    typealias OperationFactory = Matryoshka.OperationFactory<InputType, OperationType>

    /// Creates an operation for the given input value.
    func create(input: InputType) -> OperationType
}

// MARK: - Basics

/// OperationFactoryType.create() as a free function.
public func create<F: OperationFactoryType>(factory: F) -> F.InputType -> F.OperationType {
    return { input in
        return factory.create(input)
    }
}

// MARK: - Transformer

/// Maps an input value to an operation which is performed with the given
/// execution function.
public func perform<F: OperationFactoryType>(factory: F, execute: F.OperationType.ExecuteInputType -> SignalProducer<F.OperationType.ExecuteOutputType, F.OperationType.ExecuteErrorType>) -> F.InputType -> SignalProducer<F.OperationType.OutputType, F.OperationType.ErrorType> {
    return { input in
        return factory.create(input).execute(execute)
    }
}

// MARK: - Operator

/// Maps each input value to an operation which is performed with the given
/// execution function, then flattens the resulting producers (into a single
/// producer of values), according to the semantics of the given strategy.
///
/// Equivalent to: `flatMap(strategy, perform(factory, execute))`.
public func perform<F: OperationFactoryType>(strategy: FlattenStrategy, factory: F, execute: F.OperationType.ExecuteInputType -> SignalProducer<F.OperationType.ExecuteOutputType, F.OperationType.ExecuteErrorType>) -> SignalProducer<F.InputType, F.OperationType.ErrorType> -> SignalProducer<F.OperationType.OutputType, F.OperationType.ErrorType> {
    return { producer in
        return producer |> map(perform(factory, execute)) |> flatten(strategy)
    }
}
