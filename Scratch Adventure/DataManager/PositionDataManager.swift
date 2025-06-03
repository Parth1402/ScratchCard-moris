//
//  PositionDataManager.swift
//  Scratch Adventure
//
//  Created by USER on 19/05/25.
//

import Foundation

class PositionManager {
    
    static let shared = PositionManager()
    
    private let userDefaults = UserDefaults.standard
    
    private let PositionsArrayKey = "PositionsArray"
    
    
    func saveFilteredPositions(_ positions: [AddPosition]) {
        do {
            let data = try JSONEncoder().encode(positions)
            UserDefaults.standard.set(data, forKey: PositionsArrayKey)
        } catch {
            print("Error saving filtered positions: \(error.localizedDescription)")
        }
    }

    func loadFilteredPositions() -> [AddPosition] {
        guard let data = UserDefaults.standard.data(forKey: PositionsArrayKey) else {
            return []
        }
        do {
            return try JSONDecoder().decode([AddPosition].self, from: data)
        } catch {
            print("Error loading filtered positions: \(error.localizedDescription)")
            return []
        }
    }


}



class ActivityManager {
    
    static let shared = ActivityManager()
    
    private let userDefaults = UserDefaults.standard
    
    private let ActivityArrayKey = "ActivityArray"
    private let SelectedActivityArrayKey = "SelectedActivityArray"
    
    
    func saveActivities(_ activities: [String]) {
        do {
            let data = try JSONEncoder().encode(activities)
            UserDefaults.standard.set(data, forKey: ActivityArrayKey)
        } catch {
            print("Error saving activities: \(error.localizedDescription)")
        }
    }



    func loadActivities() -> [String] {
        guard let data = UserDefaults.standard.data(forKey: ActivityArrayKey) else {
            return []
        }
        do {
            return try JSONDecoder().decode([String].self, from: data)
        } catch {
            print("Error loading activities: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveSelectedActivities(_ activities: [String]) {
        do {
            let data = try JSONEncoder().encode(activities)
            UserDefaults.standard.set(data, forKey: SelectedActivityArrayKey)
        } catch {
            print("Error saving activities: \(error.localizedDescription)")
        }
    }



    func loadSelectedActivities() -> [String] {
        guard let data = UserDefaults.standard.data(forKey: SelectedActivityArrayKey) else {
            return []
        }
        do {
            return try JSONDecoder().decode([String].self, from: data)
        } catch {
            print("Error loading activities: \(error.localizedDescription)")
            return []
        }
    }


}
