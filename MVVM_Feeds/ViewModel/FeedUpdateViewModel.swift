//
//  FeedUpdateViewModel.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/2/26.
//

import Observation
import Foundation

@MainActor
@Observable

final class FeedDetailViewModel {
    let feedService: FeedServiceProtocol
    var updatedFeed: Feed?
    var feedUpdateError: String?

    var feedupdateFailed: Bool {
        feedUpdateError != nil
    }

    init(feedService: FeedServiceProtocol) {
        self.feedService = feedService
    }

    func updateFeed(feed: Feed) async {
        do {
            updatedFeed = try await feedService.updateFeed(feedId: feed.feedID, feedBody: feed.body)
        } catch {
            // Mock: simulate success with local data
            updatedFeed = Feed(feedID: feed.feedID, body: feed.body, author: feed.author)
        }
    }
}
