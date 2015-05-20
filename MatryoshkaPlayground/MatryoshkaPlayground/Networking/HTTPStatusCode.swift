// http://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml
public enum HTTPStatusCode: Equatable {
    // Informational
    case Continue
    case SwitchingProtocols
    case Processing

    // Success
    case OK
    case Created
    case Accepted
    case NonAuthoritativeInformation
    case NoContent
    case ResetContent
    case PartialContent
    case MultiStatus
    case AlreadyReported
    case IMUsed

    // Redirection
    case MultipleChoices
    case MovedPermanently
    case Found
    case SeeOther
    case NotModified
    case UseProxy
    case TemporaryRedirect
    case PermanentRedirect

    // Client Error
    case BadRequest
    case Unauthorized
    case PaymentRequired
    case Forbidden
    case NotFound
    case MethodNotAllowed
    case NotAcceptable
    case ProxyAuthenticationRequired
    case RequestTimeout
    case Conflict
    case Gone
    case LengthRequired
    case PreconditionFailed
    case PayloadTooLarge
    case URITooLong
    case UnsupportedMediaType
    case RangeNotSatisfiable
    case ExceptionFailed
    case MisdirectedRequest
    case UnprocessableEntity
    case Locked
    case FailedDependency
    case UpgradeRequired
    case PreconditionRequired
    case TooManyRequests
    case RequestHeaderFieldsTooLarge

    // Server Error
    case InternalServerError
    case NotImplemented
    case BadGateway
    case ServiceUnavailable
    case GatewayTimeout
    case HTTPVersionNotSupported
    case VariantAlsoNegotiates
    case InsufficientStorage
    case LoopDetected
    case NotExtended
    case NetworkAuthenticationRequired

    // Unknown
    case Unknown(Int)
}

public func == (lhs: HTTPStatusCode, rhs: HTTPStatusCode) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

extension HTTPStatusCode: Printable {
    public var description: String {
        return String(rawValue)
    }
}

extension HTTPStatusCode: RawRepresentable {
    public var rawValue: Int {
        switch self {
        case .Continue:
            return 100
        case .SwitchingProtocols:
            return 101
        case .Processing:
            return 102
        case .OK:
            return 200
        case .Created:
            return 201
        case .Accepted:
            return 202
        case .NonAuthoritativeInformation:
            return 203
        case .NoContent:
            return 204
        case .ResetContent:
            return 205
        case .PartialContent:
            return 206
        case .MultiStatus:
            return 207
        case .AlreadyReported:
            return 208
        case .IMUsed:
            return 226
        case .MultipleChoices:
            return 300
        case .MovedPermanently:
            return 301
        case .Found:
            return 302
        case .SeeOther:
            return 303
        case .NotModified:
            return 304
        case .UseProxy:
            return 305
        case .TemporaryRedirect:
            return 307
        case .PermanentRedirect:
            return 308
        case .BadRequest:
            return 400
        case .Unauthorized:
            return 401
        case .PaymentRequired:
            return 402
        case .Forbidden:
            return 403
        case .NotFound:
            return 404
        case .MethodNotAllowed:
            return 405
        case .NotAcceptable:
            return 406
        case .ProxyAuthenticationRequired:
            return 407
        case .RequestTimeout:
            return 408
        case .Conflict:
            return 409
        case .Gone:
            return 410
        case .LengthRequired:
            return 411
        case .PreconditionFailed:
            return 412
        case .PayloadTooLarge:
            return 413
        case .URITooLong:
            return 414
        case .UnsupportedMediaType:
            return 415
        case .RangeNotSatisfiable:
            return 416
        case .ExceptionFailed:
            return 417
        case .MisdirectedRequest:
            return 421
        case .UnprocessableEntity:
            return 422
        case .Locked:
            return 423
        case .FailedDependency:
            return 424
        case .UpgradeRequired:
            return 426
        case .PreconditionRequired:
            return 428
        case .TooManyRequests:
            return 429
        case .RequestHeaderFieldsTooLarge:
            return 431
        case .InternalServerError:
            return 500
        case .NotImplemented:
            return 501
        case .BadGateway:
            return 502
        case .ServiceUnavailable:
            return 503
        case .GatewayTimeout:
            return 504
        case .HTTPVersionNotSupported:
            return 505
        case .VariantAlsoNegotiates:
            return 506
        case .InsufficientStorage:
            return 507
        case .LoopDetected:
            return 508
        case .NotExtended:
            return 510
        case .NetworkAuthenticationRequired:
            return 511
        case let .Unknown(statusCode):
            return statusCode
        }
    }

    public init(rawValue: Int) {
        switch rawValue {
        case 100:
            self = .Continue
        case 101:
            self = .SwitchingProtocols
        case 102:
            self = .Processing
        case 200:
            self = .OK
        case 201:
            self = .Created
        case 202:
            self = .Accepted
        case 203:
            self = .NonAuthoritativeInformation
        case 204:
            self = .NoContent
        case 205:
            self = .ResetContent
        case 206:
            self = .PartialContent
        case 207:
            self = .MultiStatus
        case 208:
            self = .AlreadyReported
        case 226:
            self = .IMUsed
        case 300:
            self = .MultipleChoices
        case 301:
            self = .MovedPermanently
        case 302:
            self = .Found
        case 303:
            self = .SeeOther
        case 304:
            self = .NotModified
        case 305:
            self = .UseProxy
        case 307:
            self = .TemporaryRedirect
        case 308:
            self = .PermanentRedirect
        case 400:
            self = .BadRequest
        case 401:
            self = .Unauthorized
        case 402:
            self = .PaymentRequired
        case 403:
            self = .Forbidden
        case 404:
            self = .NotFound
        case 405:
            self = .MethodNotAllowed
        case 406:
            self = .NotAcceptable
        case 407:
            self = .ProxyAuthenticationRequired
        case 408:
            self = .RequestTimeout
        case 409:
            self = .Conflict
        case 410:
            self = .Gone
        case 411:
            self = .LengthRequired
        case 412:
            self = .PreconditionFailed
        case 413:
            self = .PayloadTooLarge
        case 414:
            self = .URITooLong
        case 415:
            self = .UnsupportedMediaType
        case 416:
            self = .RangeNotSatisfiable
        case 417:
            self = .ExceptionFailed
        case 421:
            self = .MisdirectedRequest
        case 422:
            self = .UnprocessableEntity
        case 423:
            self = .Locked
        case 424:
            self = .FailedDependency
        case 426:
            self = .UpgradeRequired
        case 428:
            self = .PreconditionRequired
        case 429:
            self = .TooManyRequests
        case 431:
            self = .RequestHeaderFieldsTooLarge
        case 500:
            self = .InternalServerError
        case 501:
            self = .NotImplemented
        case 502:
            self = .BadGateway
        case 503:
            self = .ServiceUnavailable
        case 504:
            self = .GatewayTimeout
        case 505:
            self = .HTTPVersionNotSupported
        case 506:
            self = .VariantAlsoNegotiates
        case 507:
            self = .InsufficientStorage
        case 508:
            self = .LoopDetected
        case 510:
            self = .NotExtended
        case 511:
            self = .NetworkAuthenticationRequired
        case let statusCode:
            self = .Unknown(statusCode)
        }
    }
}
