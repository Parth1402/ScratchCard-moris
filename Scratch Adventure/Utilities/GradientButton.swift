//
//  GradientButton.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 10.04.23.
//

import Foundation
import UIKit


class GradientAccentColorButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 0, y: 0)
        layer.insertSublayer(l, at: 0)
        layer.masksToBounds = true
        return l
    }()
    
    /* Other Gradient
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor.systemYellow.cgColor, UIColor.systemPink.cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 16
        layer.insertSublayer(l, at: 0)
        return l
    }()
    */
}


class GradientWhiteColorButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor(red: 0.8275, green: 0.7882, blue: 1, alpha: 1.0).cgColor /* #d3c9ff */, UIColor.white.cgColor]
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 0, y: 0)
        layer.insertSublayer(l, at: 0)
        layer.masksToBounds = true
        return l
    }()
    
}
