//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Result
import ReactiveCocoa
import Argo

public let DecodedErrorDomain = "DecodedErrorDomain"
public enum DecodedErrorCode: Int {
    case TypeMismatch = 1
    case MissingKey = 2
}

extension Decoded {
    var result: Result<T, NSError> {
        switch self {
        case let .Success(value):
            return .success(value.value)
        case .TypeMismatch(_):
            return .failure(NSError(domain: DecodedErrorDomain, code: DecodedErrorCode.TypeMismatch.rawValue, userInfo: nil))
        case .MissingKey(_):
            return .failure(NSError(domain: DecodedErrorDomain, code: DecodedErrorCode.MissingKey.rawValue, userInfo: nil))
        }
    }
}
