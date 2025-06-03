//
//  FirestoreManager.swift
//  SendPushNotifications
//
//  Created by Irakli Chkhitunidze on 12/12/23.
//

import UIKit

extension Date {
    
    func getFormattedDate(format: String)-> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}


extension Dictionary {
    func castToObject<T: Decodable>() -> T? {
        let json = try? JSONSerialization.data(withJSONObject: self)
        return json == nil ? nil : try? JSONDecoder().decode(T.self, from: json!)
    }
}

struct TrackingDataModel: Codable {
    var threeMonthlySubscription: Int
   // var estimatedRevenue: Int
    var monthlySubscription: Int
    var weeklySubscription: Int
    
    enum CodingKeys: String, CodingKey {
        case threeMonthlySubscription = "3monthsSubscription"
        case monthlySubscription, weeklySubscription
    }
}
