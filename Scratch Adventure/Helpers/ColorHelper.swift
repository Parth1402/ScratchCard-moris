//
//  ColorHelper.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-09.
//

import Foundation
import UIKit

let appColor = UIColor(hexString: "623A89")
let buttonAppLightColor = UIColor(hexString: "7C49AE")
let lightAppColor = UIColor(hexString: "AA97BD")
let boyAppColor = UIColor(hexString: "7C49AE")
let girlAppColor = UIColor(hexString: "FF439C")
let pitchOnboradingAppColor = UIColor(hexString: "EB9C9C")

extension UIColor {
    convenience init?(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
