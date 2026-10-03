//
//  ImageLoader.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/2/26.
//

import Foundation
import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    var cachedImage: UIImage?
    
    func loadImage(url: URL) async -> UIImage?  {
        if let existingCachedImage = ImageCache.shared.getImage(url: url) {
            return  existingCachedImage
        }
        else {
            var inFlightTasks = [URL: Task<UIImage?, Never>]()
            if let inFlightTask = inFlightTasks[url] {
                return await inFlightTask.value
            }
            
            let result: Task<UIImage?, Never> = Task {
                do {
                    let (data, resp) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data), let httpResponse = resp as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        ImageCache.shared.saveImage(url: url, uiImage: image)
                        return image
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                return nil
            }
            inFlightTasks[url] = result
            let image = await result.value
            inFlightTasks[url] = nil
            return image
        }
    }
}


final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    func getImage(url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }
    
    func saveImage(url: URL, uiImage: UIImage) {
        cache.setObject(uiImage, forKey: url.absoluteString as NSString)
    }
}
