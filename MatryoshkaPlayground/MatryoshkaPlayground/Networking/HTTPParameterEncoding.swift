// Copyright (c) 2014–2015 Alamofire Software Foundation (http://alamofire.org/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/**
    Used to specify the way in which a set of parameters are applied to a URL request.
*/
public enum HTTPParameterEncoding: Equatable {
    /**
        A query string to be set as or appended to any existing URL query for `GET`, `HEAD`, and `DELETE` requests, or set as the body for requests with any other HTTP method. The `Content-Type` HTTP header field of an encoded request with HTTP body is set to `application/x-www-form-urlencoded`. Since there is no published specification for how to encode collection types, the convention of appending `[]` to the key for array values (`foo[]=1&foo[]=2`), and appending the key surrounded by square brackets for nested dictionary values (`foo[bar]=baz`).
    */
    case URL

    /**
        Uses `NSJSONSerialization` to create a JSON representation of the parameters object, which is set as the body of the request. The `Content-Type` HTTP header field of an encoded request is set to `application/json`.
    */
    case JSON

    /**
        Uses `NSPropertyListSerialization` to create a plist representation of the parameters object, according to the associated format and write options values, which is set as the body of the request. The `Content-Type` HTTP header field of an encoded request is set to `application/x-plist`.
    */
    case PropertyList(NSPropertyListFormat, NSPropertyListWriteOptions)

    /**
        Creates a URL request by encoding parameters and applying them onto an existing request.
        :param: URLRequest The request to have parameters applied
        :param: parameters The parameters to apply
        :returns: A tuple containing the constructed request and the error that occurred during parameter encoding, if any.
    */
    public func encode(URLRequest: NSURLRequest, parameters: [String: AnyObject]?) -> (NSURLRequest, NSError?) {
        if parameters == nil {
            return (URLRequest, nil)
        }

        var mutableURLRequest: NSMutableURLRequest! = URLRequest.mutableCopy() as! NSMutableURLRequest
        var error: NSError? = nil

        switch self {
        case .URL:
            func query(parameters: [String: AnyObject]) -> String {
                var components: [(String, String)] = []
                for key in sorted(Array(parameters.keys), <) {
                    let value: AnyObject! = parameters[key]
                    components += self.queryComponents(key, value)
                }

                return join("&", components.map{"\($0)=\($1)"} as [String])
            }

            func encodesParametersInURL(method: HTTPMethod) -> Bool {
                switch method {
                case .GET, .HEAD, .DELETE:
                    return true
                default:
                    return false
                }
            }

            let method = HTTPMethod(rawValue: mutableURLRequest.HTTPMethod)
            if method != nil && encodesParametersInURL(method!) {
                if let URLComponents = NSURLComponents(URL: mutableURLRequest.URL!, resolvingAgainstBaseURL: false) {
                    URLComponents.percentEncodedQuery = (URLComponents.percentEncodedQuery != nil ? URLComponents.percentEncodedQuery! + "&" : "") + query(parameters!)
                    mutableURLRequest.URL = URLComponents.URL
                }
            } else {
                if mutableURLRequest.valueForHTTPHeaderField("Content-Type") == nil {
                    mutableURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                }

                mutableURLRequest.HTTPBody = query(parameters!).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            }
        case .JSON:
            let options = NSJSONWritingOptions.allZeros
            if let data = NSJSONSerialization.dataWithJSONObject(parameters!, options: options, error: &error) {
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.HTTPBody = data
            }
        case .PropertyList(let (format, options)):
            if let data = NSPropertyListSerialization.dataWithPropertyList(parameters!, format: format, options: options, error: &error) {
                mutableURLRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.HTTPBody = data
            }
        }

        return (mutableURLRequest, error)
    }

    func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.extend([(escape(key), escape("\(value)"))])
        }

        return components
    }

    func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}

private func == (lhs: [String: AnyObject]?, rhs: [String: AnyObject]?) -> Bool {
    switch (lhs, rhs) {
    case let (.Some(lhs), .Some(rhs)):
        return (lhs as NSDictionary).isEqual(rhs as NSDictionary)
    case (nil, nil):
        return true
    default:
        return false
    }
}

public func == (lhs: HTTPParameterEncoding, rhs: HTTPParameterEncoding) -> Bool {
    switch (lhs, rhs) {
    case (.URL, .URL):
        return true
    case (.JSON, .JSON):
        return true
    case let (.PropertyList(format1, writeOptions1), .PropertyList(format2, writeOptions2)):
        return format1 == format2 && writeOptions1 == writeOptions2
    default:
        return false
    }
}

extension HTTPParameterEncoding: Printable {
    public var description: String {
        switch self {
        case .URL:
            return "URL"
        case .JSON:
            return "JSON"
        case let .PropertyList(format, writeOptions):
            return "PropertyList(format: \(format), writeOptions: \(writeOptions))"
        }
    }
}
