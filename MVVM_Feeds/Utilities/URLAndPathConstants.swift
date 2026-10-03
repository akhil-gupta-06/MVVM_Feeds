//
//  URLAndPathConstants.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/3/26.
//

enum URLAndPathConstants {
    enum Auth {
        static let login = "/login"
    }
    
    enum Feed {
        static let fetchFeeds = "/feeds"
        static let addFeed = "/feeds/new"
        
        static func updateFeed(feedId: Int) -> String {
            "/feeds/\(feedId)/body/update"
        }
        static func deleteFeed(feedId: Int) -> String {
            "/feeds/\(feedId)"
        }
    }
}
