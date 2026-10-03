//
//  FeedsView.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/1/26.
//

import SwiftUI

struct FeedsView: View {
    @State var feedsViewModel = FeedViewModel(feedService: FeedService())
    @State var isNewFeed: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                switch feedsViewModel.fetchStatus {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView("Loading...")
                case .success:
                    //            feedsList - Use for Swipe actions
                    feedsScrollView
                case .failure:
                    ContentUnavailableView("No Feeds Available", systemImage: "exclamationmark.triangle")
                }
            }
            
            .navigationTitle("Feeds")
            .navigationBarBackButtonHidden()
            .navigationDestination(for: Feed.ID.self) { feedID in
                if let index = feedsViewModel.feeds.firstIndex(where: { $0.feedID == feedID }) {
                    let selectedFeed = $feedsViewModel.feeds[index]
                    FeedDetailView(feed: selectedFeed)
                }
            }
            .navigationDestination(isPresented: $isNewFeed) {
                NewFeedView(feedsViewModel: feedsViewModel)
            }
            .toolbar{
                ToolbarItem {
                    Button {
                        isNewFeed = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                guard feedsViewModel.feeds.isEmpty else { return }
                await feedsViewModel.fetchFeeds()
            }
        }
    }
    
    // List: built-in swipe actions, refreshable, cell recycling like UITableView.
    // Best for standard row-based UI with system behaviours.
    /*var feedsList: some View {
     List {
     ForEach(feedsViewModel.feeds) { feed in
     NavigationLink(value: feed) {
     FeedRow(feed: feed, isfeedsScrollViewBased: false)
     }
     .swipeActions(edge: .trailing) {
     Button(role: .destructive) {
     Task { await feedsViewModel.deleteFeed(feed: feed) }
     } label: {
     Label("Delete", systemImage: "trash")
     }
     }
     }
     }
     .listStyle(.plain)
     .refreshable {
     await feedsViewModel.fetchFeeds()
     }
     }
     */
    // ScrollView + LazyVStack: full layout control, no list chrome.
    // Swipe actions don't work here — needs custom gesture handling.
    var feedsScrollView: some View {
        ScrollView {
            LazyVStack {
                ForEach(feedsViewModel.feeds) { feed in
                    NavigationLink(value: feed.id) {
                        FeedRow(feed: feed, isfeedsScrollViewBased: true)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .refreshable {
            await feedsViewModel.fetchFeeds()
        }
    }
}

struct FeedRow: View {
    
    let feed: Feed
    let isfeedsScrollViewBased: Bool
    
    var body: some View {
        VStack {
            /// Avatar
            HStack {
                if let avatarURL = feed.author?.avatarURL {
                    CachedImage(avatarURL: avatarURL)
                }
                /// Author, feed body
                VStack(alignment: .leading, spacing: 5)  {
                    Text(feed.author?.name ?? "")
                        .font(.headline)
                    Text(feed.body)
                }
                .padding(5)
                .frame(maxWidth: .infinity, alignment: .leading)
                if isfeedsScrollViewBased {
                    Image(systemName: "chevron.right")
                        .padding(.horizontal, 5)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            if isfeedsScrollViewBased {
                Rectangle()
                    .frame(height: 0.5)
            }
        }
    }
}

struct CachedImage: View {
    let avatarURL: URL
    @State var image: UIImage?
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(.rect(cornerRadius: 5))
            } else {
                ProgressView()
            }
        }
        .task(id: avatarURL) {
            image = await ImageLoader.shared.loadImage(url: avatarURL)
        }
    }
}

#Preview {
    FeedRow(feed: Feed(feedID: 01, body: "Test body Test bodyTest bodyTest bodyTest bodyTest bodyTest bodyTest bodyTest bodyTest bodyTest body", author: Author(avatarURL: URL(string: "https://i.pravatar.cc/150?u=2"), name: "Akhil")), isfeedsScrollViewBased: false)
    //    FeedsView()
}
