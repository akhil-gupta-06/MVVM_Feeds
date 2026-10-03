//
//  FeedDetailView.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/2/26.
//

import SwiftUI

struct FeedDetailView: View {
    let feed: Feed
    let feedViewModel: FeedViewModel
    @State private var feedDetailVM = FeedDetailViewModel(feedService: FeedService())
    @State private var editedBody: String
    @State private var showAlert = false
    @Environment(\.dismiss) var dismiss

    init(feed: Feed, feedViewModel: FeedViewModel) {
        self.feed = feed
        self.feedViewModel = feedViewModel
        self._editedBody = State(initialValue: feed.body)
    }

    var body: some View {
        VStack {
            TextField("Body", text: $editedBody, axis: .vertical)
            Spacer()
        }
        .padding()
        .navigationTitle("Edit Feed")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    Task {
                        var feedToBeUpdated = feed
                        feedToBeUpdated.body = editedBody
                        await feedDetailVM.updateFeed(feed: feedToBeUpdated)
                        showAlert = feedDetailVM.feedupdateFailed
                        if !showAlert, let updatedFeed = feedDetailVM.updatedFeed,
                           let index = feedViewModel.feeds.firstIndex(where: { $0.feedID == updatedFeed.feedID }) {
                            feedViewModel.feeds[index] = updatedFeed
                            dismiss()
                        }
                    }
                }
            }
        }
        .alert("Update Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Updating the feed failed. Please try again.")
        }
    }
}

#Preview {
    let feed = Feed(feedID: 01, body: "Test body", author: Author(avatarURL: nil, name: "Akhil"))
    FeedDetailView(feed: feed, feedViewModel: FeedViewModel(feedService: FeedService()))
}
