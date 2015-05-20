//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Runes
import Argo

public struct User: Equatable {
    public var id: Int
    public var username: String

    public init(id: Int, username: String) {
        self.id = id
        self.username = username
    }
}

public func == (lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id
        && lhs.username == rhs.username
}

extension User: Printable {
    public var description: String {
        return "User(id: \(id), username: \(username))"
    }
}

extension User: Decodable {
    private static func create(id: Int)(username: String) -> User {
        return User(id: id, username: username)
    }

    public static func decode(json: JSON) -> Decoded<User> {
        return create
            <^> json <| "id"
            <*> json <| "username"
    }
}
