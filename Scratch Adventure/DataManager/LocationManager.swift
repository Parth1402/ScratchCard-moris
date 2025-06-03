//
//  LocationManager.swift
//  Scratch Adventure
//
//  Created by USER on 29/04/25.
//

import Foundation

class LocationManager {
    
    static let shared = LocationManager()
    
    private let userDefaults = UserDefaults.standard
    
    private let recentLocationsKey = "recentLocations"
    private let CurrentLocationKey = "CurrentLocation"
    private let markedLocationKey = "markedLocation"
    private let maxRecentLocations = 5
    
    func saveRecentLocations(_ locations: [ExperienceLocation]) {
        do {
            let data = try JSONEncoder().encode(locations)
            userDefaults.set(data, forKey: recentLocationsKey)
        } catch {
            print("Error saving recent locations: \(error.localizedDescription)")
        }
    }
    
    func loadRecentLocations() -> [ExperienceLocation] {
        guard let data = userDefaults.data(forKey: recentLocationsKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([ExperienceLocation].self, from: data)
        } catch {
            print("Error loading recent locations: \(error.localizedDescription)")
            return []
        }
    }
    
    func addRecentLocation(_ location: ExperienceLocation) {
        var recentLocations = loadRecentLocations()
        
        // Remove if already exists
        recentLocations.removeAll { $0 == location }
        
        // Add to beginning
        recentLocations.insert(location, at: 0)
        
        // Keep only max number of locations
        if recentLocations.count > maxRecentLocations {
            recentLocations = Array(recentLocations.prefix(maxRecentLocations))
        }
        
        saveRecentLocations(recentLocations)
    }
    
    func saveCurrentLocation(_ location: ExperienceLocation) {
        do {
            let data = try JSONEncoder().encode(location)
            UserDefaults.standard.set(data, forKey: CurrentLocationKey)
        } catch {
            print("Error saving current location: \(error.localizedDescription)")
        }
    }
    
    
    
    func loadCurrentLocation() -> ExperienceLocation {
        guard let data = UserDefaults.standard.data(forKey: CurrentLocationKey) else {
            return ExperienceLocation() // return default if not found
        }
        
        do {
            return try JSONDecoder().decode(ExperienceLocation.self, from: data)
        } catch {
            print("Error decoding current location: \(error.localizedDescription)")
            return ExperienceLocation()
        }
    }
    
    func RecentlyMarkedsaveLocations(_ sections: [LocationItem]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(sections) {
            UserDefaults.standard.set(encoded, forKey: markedLocationKey)
        }
    }
    
    
    func RecentlyMarkedloadLocations() -> [LocationItem] {
        if let data = UserDefaults.standard.data(forKey: markedLocationKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([LocationItem].self, from: data) {
                return decoded
            }
        }
        return []
    }
    
    
    
}
