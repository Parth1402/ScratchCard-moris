//
//  VaultDataMAnager.swift
//  Scratch Adventure
//
//  Created by USER on 26/05/25.
//

import Foundation
import UIKit

extension Notification.Name {
    static let mediaUpdated = Notification.Name("mediaUpdated")
    static let AudioAlert = Notification.Name("AudioAlert")
    static let VideoAlert = Notification.Name("VideoAlert")
}

struct MediaItem: Codable {
    let type: String // "image" or "video"
    let data: Data
}

class VaultDataManager {
    
    static let shared = VaultDataManager()
    private let userDefaults = UserDefaults.standard
    private let MediaArrayKey = "SavedMediaArray"

    private init() {}

    // MARK: - Save Media
    func saveMedia(type: String, data: Data) {
        var currentMedia = fetchMediaArray()
        let newItem = MediaItem(type: type, data: data)
        currentMedia.append(newItem)
        
        if let encoded = try? JSONEncoder().encode(currentMedia) {
            userDefaults.set(encoded, forKey: MediaArrayKey)
        } else {
            print("❌ Failed to encode media array.")
        }
    }
    
    // MARK: - Fetch Media
    func fetchMediaArray() -> [MediaItem] {
        guard let data = userDefaults.data(forKey: MediaArrayKey),
              let items = try? JSONDecoder().decode([MediaItem].self, from: data) else {
            return []
        }
        return items
    }
    
    // MARK: - Show Media
    func showMedia() {
        let mediaItems = fetchMediaArray()
        
        for item in mediaItems {
            if item.type == "image", let image = UIImage(data: item.data) {
                print("📷 Display Image")
                // imageView.image = image
            } else if item.type == "video" {
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mov")
                do {
                    try item.data.write(to: tempURL)
                    print("🎥 Play video from \(tempURL)")
                    // Use AVPlayer to play from tempURL
                } catch {
                    print("❌ Could not write video file:", error)
                }
            }
        }
    }
    
    func deleteMedia(at index: Int) {
        var currentMedia = fetchMediaArray()
        guard index < currentMedia.count else { return }
        currentMedia.remove(at: index)
        
        if let encoded = try? JSONEncoder().encode(currentMedia) {
            userDefaults.set(encoded, forKey: MediaArrayKey)
            NotificationCenter.default.post(name: .mediaUpdated, object: nil)
        } else {
            print("❌ Failed to encode updated media array.")
        }
    }

}
