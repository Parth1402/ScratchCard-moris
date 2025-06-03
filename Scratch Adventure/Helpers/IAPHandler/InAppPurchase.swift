//
//  InAppPurchase.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 11.01.22.
//

import Foundation
import SwiftyStoreKit
import UIKit


var sharedSecret = "7607720ad221489e942ccb8feec4923f"

enum InAppPurchaseProduct: String {
    case ovulioBabyUnlockAllSubscriptionWeekly = "com.MauriceWirthInternetagentur.OvulioBaby.UnlockAllWeekly"
    case ovulioBabyUnlockAllSubscriptionMonthly = "com.MauriceWirthInternetagentur.OvulioBaby.UnlockAllMonthly"
    case ovulioBabyUnlockAllSubscription3Months = "com.MauriceWirthInternetagentur.OvulioBaby.UnlockAll3Months"
    case ovulioBabyUnlockAllSubscriptionLifetime = "com.MauriceWirthInternetagentur.OvulioBaby.OvulioBabyLifetime"
    case ovulioBabyUnlockAllSubscriptionLifetime1 = "com.MauriceWirthInternetagentur.OvulioBaby.OvulioBabyLifetime1"
}

class NetworkActivityIndicatorManager: NSObject {
    
    private static var loadingCount = 0
    
    class func NetworkOperationStarted() {
        
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        loadingCount += 1
        
    }
    
    
    class func NetworkOperationFinished() {
        
        if loadingCount > 0 {
            loadingCount -= 1
        }
        
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
    
}
