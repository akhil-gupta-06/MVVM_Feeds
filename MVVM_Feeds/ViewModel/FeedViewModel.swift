//
//  FeedViewModel.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/2/26.
//

import Observation
import Foundation

enum FetchStatus {
    case idle
    case loading
    case success
    case failure
}

@MainActor
@Observable

final class FeedViewModel {
    var feeds: [Feed] = []
    var fetchStatus: FetchStatus = .idle
    var feedFetchError: String?
    let feedService: FeedServiceProtocol
    
    init(feedService: FeedServiceProtocol) {
        self.feedService = feedService
    }
    
    func fetchFeeds() async {
        fetchStatus = .loading
        do {
            feeds = try await feedService.fetchFeeds(afterTimeStamp: nil)
            fetchStatus = .success
        } catch {
            try? await Task.sleep(for: .seconds(1))
            fetchFeedsMock()
            /*fetchStatus = .failure
             feedFetchError = error.localizedDescription*/
        }
    }
    
    func fetchFeedsMock() {
        guard let fileURL = Bundle.main.url(forResource: "feed", withExtension: "json") else {
            return
        }
        do {
            let data = try Data(NSData(contentsOf: fileURL))
            feeds = try JSONDecoder().decode([Feed].self, from: data)
            fetchStatus = .success
        } catch {
            fetchStatus = .failure
            feedFetchError = error.localizedDescription
        }
    }
    
    func addFeed(feedBody: String, feedAuthor: Author?) async {
        do {
            let feed = try await feedService.addFeed(feedBody: feedBody, feedAuthor: feedAuthor)
            feeds.insert(feed, at: 0)
        } catch {
            let mockFeed = Feed(feedID: 100, body: feedBody, createdAt: "2026-09-01T08:23:00Z", author: feedAuthor)
            feeds.insert(mockFeed, at: 0)
        }
    }
    
    /// live feed (prepending)
    func prePendFeeds() async {
        while !Task.isCancelled {
            try? await Task.sleep(for: .seconds(5))
            
            guard let lastTimestamp = feeds.first?.createdAt else { continue }
            do {
                let newFeeds = try await feedService.fetchFeeds(afterTimeStamp: lastTimestamp)
                let existingFeedIds = Set(feeds.map { $0.id })
                let uniqueNewFeeds = newFeeds.filter { !existingFeedIds.contains($0.id) }
                if !uniqueNewFeeds.isEmpty {
                    feeds = uniqueNewFeeds + feeds
                }
            } catch {
                print(error.localizedDescription)
                let prePendfeed = Feed(feedID: 101, body: "A Beautiful day.", createdAt: "2026-09-01T08:23:00Z", author: Author(avatarURL: URL(string: "https://i.pravatar.cc/150?u=2"), name: "Akhil"))
                feeds = [prePendfeed] + feeds
            }
        }
    }
}

