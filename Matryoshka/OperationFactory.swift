//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

/// A closure-based operation factory.
public struct OperationFactory<Input, Operation: OperationType>: OperationFactoryType {
    private let createClosure: Input -> Operation

    /// Creates a closure-based operation factory with the given closure.
    public init(_ create: Input -> Operation) {
        createClosure = create
    }

    public func create(input: Input) -> Operation {
        return createClosure(input)
    }
}

extension OperationFactory {
    /// Creates a closure-based operation factory that wraps the given operation
    /// factory.
    public init<F: OperationFactoryType where F.InputType == Input, F.OperationType == Operation>(_ factory: F) {
        self.init({ input in
            return factory.create(input)
        })
    }
}
