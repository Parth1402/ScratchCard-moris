//
//  UIActivityIndicatorView Extension.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 14.12.21.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    
    func assignColor(_ color: UIColor) {
        if #available(iOS 13.0, *) {
            style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
        self.color = color
    }
    
}
