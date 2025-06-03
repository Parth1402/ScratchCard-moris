//
//  Extension.swift
//  Ovulation
//
//  Created by Admin on 15/10/23.
//

import Foundation
import UIKit

extension UIView {
    func applyRoundedBackgroundShadow(radius: CGFloat, backgroundColor: UIColor, shadowColor: UIColor, shadowOpacity: Float, shadowRadius: CGFloat) {
        layer.cornerRadius = radius
        self.backgroundColor = backgroundColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowColor = shadowColor.cgColor
    }
}

// MARK: Poppins Font Names :-
enum AppFonts: String {
    case Poppins_Bold = "Poppins-Bold"
    case Poppins_Light = "Poppins-Light"
    case Poppins_Medium = "Poppins-Medium"
    case Poppins_Regular = "Poppins-Regular"
    case Poppins_SemiBold = "Poppins-SemiBold"
}

extension UIFont {
    
    func poppinsBold(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: AppFonts.Poppins_Bold.rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    func poppinsMedium(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: AppFonts.Poppins_Medium.rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    func poppinsLight(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: AppFonts.Poppins_Light.rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    func poppinsRegular(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: AppFonts.Poppins_Regular.rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    func poppinsSemiBold(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: AppFonts.Poppins_SemiBold.rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}


// MARK: - UIView Extension -

extension UIView {
    
    /**
     Rotate a view by specified degrees
     - parameter angle: angle in degrees
     */
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        // let rotation = CGAffineTransformRotate(self.transform, radians)
        let rotation =  CGAffineTransform(rotationAngle: radians)
        self.transform = rotation
    }
    
    func start_pendulamAnimationView()
    {
        self.transform = CGAffineTransform(rotationAngle: -0.4)
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseInOut, .autoreverse , .repeat], animations: {
            self.transform = CGAffineTransform(rotationAngle: 0.4)
        }, completion: nil)
    }
    func stop_pendulamAnimationView()
    {
        self.layer.removeAllAnimations()
        self.transform = CGAffineTransform(rotationAngle: 0)
    }
    
    func setBorder(width: CGFloat = 0.5, radius:CGFloat, color:UIColor = UIColor.clear){
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
    }
    
    
    func loopViewHierarchy(block: (_ view: UIView, _ stop: inout Bool) -> ()) {
        var stop = false
        block(self, &stop)
        if !stop {
            self.subviews.forEach { $0.loopViewHierarchy(block: block) }
        }
    }
    
    var saferAreaLayoutGuide: UILayoutGuide {
        get {
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide
            } else {
                return self.layoutMarginsGuide
            }
        }
    }
}



extension UITextView {
    
    func setLineHeight(_ lineHeight: CGFloat) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight // Adjust this value as needed
        let attributedText = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        self.attributedText = attributedText
        
    }
    
}


extension UILabel {
    
    public func zeroLineSpace() {
        
        let s = NSMutableAttributedString(string: self.text!)
        let style = NSMutableParagraphStyle()
        let lineHeight = self.font.pointSize - self.font.ascender + self.font.capHeight
        let offset = self.font.capHeight - self.font.ascender
        let range = NSMakeRange(0, self.text!.count)
        style.maximumLineHeight = lineHeight + 4
        style.minimumLineHeight = lineHeight + 4
        style.alignment = self.textAlignment
        s.addAttribute(.paragraphStyle, value: style, range: range)
        s.addAttribute(.baselineOffset, value: offset, range: range)
        self.attributedText = s
        
    }
    
}


extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment

        let attrString = NSMutableAttributedString()
        if (self.attributedText != nil) {
            attrString.append( self.attributedText!)
        } else {
            attrString.append( NSMutableAttributedString(string: self.text!))
            attrString.addAttribute(NSAttributedString.Key.font, value: self.font, range: NSMakeRange(0, attrString.length))
        }
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
    
}


extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}
