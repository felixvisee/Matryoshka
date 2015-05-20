//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

public func == <Key: Equatable, Value: Equatable>(lhs: [Key: Value]?, rhs: [Key: Value]?) -> Bool {
    switch (lhs, rhs) {
    case let (.Some(lhs), .Some(rhs)):
        return lhs == rhs
    case (nil, nil):
        return true
    default:
        return false
    }
}
