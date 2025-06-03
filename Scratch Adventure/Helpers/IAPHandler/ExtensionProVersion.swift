//
//  InAppPurchase.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 11.01.22.
//

import Foundation
import UIKit


func isUserProMember() -> Bool {
    
    // User Defaults
    let userDefaults = UserDefaults.standard
    
    // For UGC Creators
    var didUnlockAppCompletely: Bool = true
    if userDefaults.value(forKey: "didUnlockAppCompletely") == nil || userDefaults.value(forKey: "didUnlockAppCompletely") as! Bool == false {
        
        didUnlockAppCompletely = false
        
    }
    
    var didOvulioBabyWeeklyPurchase: Bool = true
    if userDefaults.value(forKey: "didOvulioBabyWeeklySubscription") == nil || userDefaults.value(forKey: "didOvulioBabyWeeklySubscription") as! Bool == false {
        
        didOvulioBabyWeeklyPurchase = false
        
    }
    
    
    var didOvulioBabyMonthlySubscription: Bool = true
    if userDefaults.value(forKey: "didOvulioBabyMonthlySubscription") == nil || userDefaults.value(forKey: "didOvulioBabyMonthlySubscription") as! Bool == false {
        
        didOvulioBabyMonthlySubscription = false
        
    }
    
    
    var didOvulioBaby3MonthsSubscription: Bool = true
    if userDefaults.value(forKey: "didOvulioBaby3MonthsSubscription") == nil || userDefaults.value(forKey: "didOvulioBaby3MonthsSubscription") as! Bool == false {
        
        didOvulioBaby3MonthsSubscription = false
        
    }
    
    
    var didOvulioBabyLifetimeSubscription: Bool = true
    if userDefaults.value(forKey: "didOvulioBabyLifetimeSubscription") == nil || userDefaults.value(forKey: "didOvulioBabyLifetimeSubscription") as! Bool == false {
        
        didOvulioBabyLifetimeSubscription = false
        
    }
    
    
    
    if didOvulioBabyWeeklyPurchase == false && didOvulioBabyMonthlySubscription == false && didOvulioBaby3MonthsSubscription == false && didOvulioBabyLifetimeSubscription == false && didUnlockAppCompletely == false {
        
        return false
        
    } else {
        
        return true
        
    }
    
}
