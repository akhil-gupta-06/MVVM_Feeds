//
//  FeedDetailView.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/2/26.
//

import SwiftUI

struct FeedDetailView: View {
    @Binding var feed: Feed
    @State private var feedDetailVM = FeedDetailViewModel(feedService: FeedService())
    @State private var editedBody: String = ""
    @State private var showAlert = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            TextField("Body", text: $editedBody, axis: .vertical)
            Spacer()
        }
        .padding()
        .onAppear { editedBody = feed.body }
        .navigationTitle("Edit Feed")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    Task {
                        var feedToBeUpdated = feed
                        feedToBeUpdated.body = editedBody
                        await feedDetailVM.updateFeed(feed: feedToBeUpdated)
                        showAlert = feedDetailVM.feedupdateFailed
                        if !showAlert, let updatedFeed = feedDetailVM.updatedFeed {
                            feed = updatedFeed
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
    @Previewable @State var feed = Feed(feedID: 01, body: "Test body", author: Author(avatarURL: nil, name: "Akhil"))
    FeedDetailView(feed: $feed)
}
