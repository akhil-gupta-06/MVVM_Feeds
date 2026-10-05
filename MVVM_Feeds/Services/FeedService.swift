//
//  FeedService.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/2/26.
//

protocol FeedServiceProtocol {
    func fetchFeeds(afterTimeStamp: String?) async throws -> [Feed]
    func updateFeed(feedId: Int, feedBody: String) async throws -> Feed
    func addFeed(feedBody: String, feedAuthor: Author?) async throws -> Feed
    func deleteFeed(feedId: Int) async throws
}

class FeedService: FeedServiceProtocol {
    let networkService: NetworkClient
    
    init(networkService: NetworkClient = .shared) {
        self.networkService = networkService
    }
    
    func fetchFeeds(afterTimeStamp: String? = nil) async throws -> [Feed] {
        var params: [String: String] = [:]
        if let ts = afterTimeStamp {
            params["timeStamp"] = ts
        }
        return try await self.networkService.makeCall(path: URLAndPathConstants.Feed.fetchFeeds, queryParams: params)
    }
    
    func updateFeed(feedId: Int, feedBody: String) async throws -> Feed {
        let updateFeedRequest = UpdateFeedRequest(feedBody: feedBody, feedId: feedId)
        return try await self.networkService.makeCall(path: URLAndPathConstants.Feed.updateFeed(feedId: feedId), httpMethod: "PUT", body: updateFeedRequest)
    }

    func addFeed(feedBody: String, feedAuthor: Author?) async throws -> Feed {
        let addfeedRequest = NewFeedRequest(feedBody: feedBody, author: feedAuthor)
        return try await self.networkService.makeCall(path: URLAndPathConstants.Feed.addFeed, httpMethod: "POST", body: addfeedRequest)
    }
    
    func deleteFeed(feedId: Int) async throws {
        let _: EmptyResponse = try await self.networkService.makeCall(path: URLAndPathConstants.Feed.deleteFeed(feedId: feedId), httpMethod: "DELETE")
    }
    
}
