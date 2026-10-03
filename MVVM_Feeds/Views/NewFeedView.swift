//
//  NewFeedView.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/3/26.
//

import SwiftUI

struct NewFeedView: View {
    let feedsViewModel: FeedViewModel
    @State var feedBody = ""
    @Environment(\.dismiss) var dismiss
    
    init(feedsViewModel: FeedViewModel) {
        self.feedsViewModel = feedsViewModel
    }
    
    var body: some View {
        VStack {
            TextField("Enter feed", text: $feedBody)
        }
        .navigationTitle("Add Feed")
        .toolbar{
            ToolbarItem {
                Button("Save") {
                    Task {
                        await feedsViewModel.addFeed(feedBody: feedBody, feedAuthor: Author(avatarURL: URL(string: "https://i.pravatar.cc/150?u=2"), name: "New Feed."))
                        dismiss()
                    }
                }
            }
        }
        
    }
}

#Preview {
    NewFeedView(feedsViewModel: FeedViewModel(feedService: FeedService()))
}
