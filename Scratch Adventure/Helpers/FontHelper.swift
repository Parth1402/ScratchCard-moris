//
//  FontHelper.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-09.
//

import Foundation

import UIKit

struct AppFontName {
    static let regular = "Poppins-Regular"
    static let bold = "Poppins-Bold"
    static let medium = "Poppins-SemiBold"
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    static var isOverrided: Bool = false

    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            return UIFont(name: AppFontName.regular, size: size + 6)!
//        }else{
            return UIFont(name: AppFontName.regular, size: size)!
//        }
    }

    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            return UIFont(name: AppFontName.bold, size: size + 6)!
//        }else{
            return UIFont(name: AppFontName.bold, size: size)!
//        }
    }

    @objc class func mymediumSystemFont(ofSize size: CGFloat) -> UIFont {
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            return UIFont(name: AppFontName.medium, size: size + 6)!
//        }else{
            return UIFont(name: AppFontName.medium, size: size)!
//        }
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = AppFontName.regular
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = AppFontName.bold
        case "CTFontObliqueUsage":
            fontName = AppFontName.medium
        default:
            fontName = AppFontName.regular
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }

    class func overrideInitialize() {
        guard self == UIFont.self, !isOverrided else { return }

        isOverrided = true

        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }

        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }

        if let mediumSystemFontMethod = class_getClassMethod(self, #selector(mymediumSystemFont(ofSize:))),
            let mymediumSystemFontMethod = class_getClassMethod(self, #selector(mymediumSystemFont(ofSize:))) {
            method_exchangeImplementations(mediumSystemFontMethod, mymediumSystemFontMethod)
        }

        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))),
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
