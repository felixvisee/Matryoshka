# Matryoshka

> A matryoshka doll, also known as Russian nesting doll or Russian doll, refers to a set of wooden dolls of decreasing size placed one inside the other. — [Wikipedia](http://en.wikipedia.org/wiki/Matryoshka_doll)

## Introduction

Matryoshka is more of an architectural approach and structural help than an actual framework. It is fundamentally build around the idea of creating a [`SignalProducer`](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/swift-development/ReactiveCocoa/Swift/SignalProducer.swift) that, when started, will execute a task with a given input, then forward the results upon the produced [`Signal`](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/swift-development/ReactiveCocoa/Swift/Signal.swift). This can be represented as a function:

```swift
Input -> SignalProducer<Output, Error>
```

Very often, a task can be divided into subtasks or transformed into another task, enabling delegation of its actual execution to another function of similar signature. Again, this can be represented as a function:

```swift
Input -> (ExecuteInput -> SignalProducer<ExecuteOutput, ExecuteError>) -> SignalProducer<Output, Error>
```

Splitting up the execution of a task into multiple such functions can have several benefits, including greater *reusability*, *composability* and *testability*.

Matryoshka provides a few very basic types and functions that help separating the initialization and execution of such operations. It also provides some handy signal producer operators and transformers that ease chaining and nesting.

## Documentation

Please take a look at the code, it ain't much anyways 😉

## Playground

There is a [playground](https://github.com/felixjendrusch/Matryoshka/blob/master/MatryoshkaPlayground/MatryoshkaPlayground.playground/Contents.swift) and an accompanying [project](https://github.com/felixjendrusch/Matryoshka/tree/master/MatryoshkaPlayground) that implements a network layer and a few operations of the official [SoundCloud API](https://developers.soundcloud.com). It's very basic, just have a look 😅

## Integration

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa.

1. Add Matryoshka to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

  ```
  github "felixjendrusch/Matryoshka" ~> 0.1
  ```

2. Run `carthage update` to fetch and build Matryoshka and its dependencies.

3. [Make sure your application's target links against `Matryoshka.framework` and copies all relevant frameworks into its application bundle (iOS); or embeds the binaries of all relevant frameworks (Mac).](https://github.com/carthage/carthage#getting-started)
