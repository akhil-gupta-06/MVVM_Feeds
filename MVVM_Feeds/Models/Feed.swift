//
//  Feed.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/2/26.
//

import Foundation

struct FeedPage: Hashable, Decodable {
    let feeds: [Feed]
    let nextFeedsCusrsor: String?
}

/// Server has "feedId" as unique key
struct Feed: Identifiable, Hashable, Decodable {
    let feedID: Int
    var id: Int { feedID }
    var body: String
    let createdAt: String
    let author: Author?
    
    enum CodingKeys: String, CodingKey {
        case body, author, createdAt
        case feedID = "feedId"
    }
}

struct Author: Hashable, Decodable, Encodable {
    let avatarURL: URL?
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatarUrl"
        case name
    }
}

/// Server has NO unique key
struct FeedWithNoId: Hashable, Decodable {
    let body: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case body = "feedBody"
        case name
    }
}

// Identity handled at the ForEach - NO unique key at server
// ForEach(Array(feeds.enumerated()), id: \.offset) { index, feed in
//     Text(feed.body)
// }

struct NewFeedRequest: Encodable {
    let feedBody: String
    let author: Author?
}


struct UpdateFeedRequest: Encodable {
    let feedBody: String
    let feedId: Int
}
