//
//  File.swift
//  Ovulio Baby
//
//  Created by Maurice Wirth on 28.12.24.
//

import Foundation

class MultiLanguage {
    
    let APPLE_LANGUAGE_KEY = "AppleLanguages"
    static var MultiLanguageConst = MultiLanguage()
    
    /// get current Apple language
    func currentAppleLanguage() -> String {
        
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        
        return String(current.prefix(2))
        
    }
    
    
    
    func currentAppleLanguageAsFinalString() -> String {
        
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        
        if String(current.prefix(2)) == "en" {
            return "English"
        } else if String(current.prefix(2)) == "es" {
            return "Spanish"
        } else if String(current.prefix(2)) == "fr" {
            return "French"
        } else if String(current.prefix(2)) == "it" {
            return "Italian"
        } else {
            return "Deutsch"
        }
        
    }
    
    
    
    /// set @lang to be the first in Applelanguages list
    func setAppleLanguageTo(lang: String) {
        
        let userdef = UserDefaults.standard
        userdef.setValue([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
        
    }
    
}
