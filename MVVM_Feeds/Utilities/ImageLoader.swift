//
//  ImageLoader.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/2/26.
//

import Foundation
import UIKit

actor ImageLoader {
    static let shared = ImageLoader()
    private var inFlightTasks = [URL: Task<UIImage?, Never>]()

    func loadImage(url: URL) async -> UIImage? {
        if let cached = await ImageCache.shared.getImage(url: url) {
            return cached
        }

        if let existing = inFlightTasks[url] {
            return await existing.value
        }

        let task = Task<UIImage?, Never> {
            do {
                let (data, resp) = try await URLSession.shared.data(from: url)
                if let httpResponse = resp as? HTTPURLResponse, httpResponse.statusCode == 200,
                   let image = UIImage(data: data) {
                    await ImageCache.shared.saveImage(url: url, uiImage: image)
                    return image
                }
            } catch {
                print(error.localizedDescription)
            }
            return nil
        }

        inFlightTasks[url] = task
        let image = await task.value
        inFlightTasks[url] = nil
        return image
    }
}


actor ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    func getImage(url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }
    
    func saveImage(url: URL, uiImage: UIImage) {
        cache.setObject(uiImage, forKey: url.absoluteString as NSString)
    }
}
