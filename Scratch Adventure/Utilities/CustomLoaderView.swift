//
//  CustomLoaderView.swift
//  Ovulio Baby
//
//  Created by USER on 18/04/25.
//

import Foundation
import UIKit

class PinkCircleLoader: UIView {

    private let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupCircle()
        startAnimating()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCircle()
        startAnimating()
    }

    private func setupCircle() {
        let lineWidth: CGFloat = 6
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: CGFloat.pi / 2,
            clockwise: true
        )

        shapeLayer.path = circlePath.cgPath
        //shapeLayer.strokeColor = UIColor(hex: "#FF76B7")?.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 0.7
        layer.addSublayer(shapeLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        setupCircle()
    }

    func startAnimating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        layer.add(rotation, forKey: "rotate")
    }
}


extension UIViewController {

        func showCustomLoader() {
            // Avoid duplicates
            guard view.viewWithTag(9999) == nil else { return }

            // Create the main background view
            let backgroundView = UIView(frame: view.bounds)
            backgroundView.tag = 9999
            backgroundView.alpha = 0 // For fade-in effect

            // Set heart-pattern background using UIImageView
            if let patternImage = UIImage(named: "appBackgroundImage") {
                let backgroundImageView = UIImageView(image: patternImage)
                backgroundImageView.frame = backgroundView.bounds
                backgroundImageView.contentMode = .scaleAspectFill
                backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                backgroundView.addSubview(backgroundImageView)
            } else {
                // Fallback to light pink if image not found
                backgroundView.backgroundColor = UIColor(red: 1.0, green: 0.94, blue: 0.95, alpha: 1.0)
            }

            // Add backgroundView to main view
            view.addSubview(backgroundView)

            // Loader
            let loader = PinkCircleLoader(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            loader.center = CGPoint(x: view.center.x, y: view.center.y - 20)
            backgroundView.addSubview(loader)

            // Label
            let label = UILabel()
            label.text = "Generating names"
            label.textColor = appColor // Customize this global color
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: loader.frame.maxY + 16, width: view.frame.width, height: 22)
            label.center.x = view.center.x
            backgroundView.addSubview(label)

            // Animate fade-in
            UIView.animate(withDuration: 0.25) {
                backgroundView.alpha = 1
            }
        }

        func hideCustomLoader() {
            if let loaderView = view.viewWithTag(9999) {
                UIView.animate(withDuration: 0.25, animations: {
                    loaderView.alpha = 0
                }) { _ in
                    loaderView.removeFromSuperview()
                }
            }
        }
    }

