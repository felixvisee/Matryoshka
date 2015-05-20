//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Runes
import Argo

public struct Track: Equatable {
    public var id: Int
    public var userId: Int
    public var title: String

    public init(id: Int, userId: Int, title: String) {
        self.id = id
        self.userId = userId
        self.title = title
    }
}

public func == (lhs: Track, rhs: Track) -> Bool {
    return lhs.id == rhs.id
        && lhs.userId == rhs.userId
        && lhs.title == rhs.title
}

extension Track: Printable {
    public var description: String {
        return "Track(id: \(id), userId: \(userId), title: \(title))"
    }
}

extension Track: Decodable {
    private static func create(id: Int)(userId: Int)(title: String) -> Track {
        return Track(id: id, userId: userId, title: title)
    }

    public static func decode(json: JSON) -> Decoded<Track> {
        return create
            <^> json <| "id"
            <*> json <| "user_id"
            <*> json <| "title"
    }
}
