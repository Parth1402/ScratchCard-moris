//
//  ReviewAlertView.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 02.07.22.
//

import Foundation
import UIKit
import SwiftyStarRatingView


class ReviewAlertView: UIView {
    
    let appIconImageView: UIImageView = {
        
        let imageViewAppIcon = UIImageView()
        imageViewAppIcon.backgroundColor = UIColor.clear
        imageViewAppIcon.contentMode = .scaleAspectFit
        imageViewAppIcon.image = UIImage(named: "Ovulio Baby App Icon")
        imageViewAppIcon.layer.cornerRadius = 20.0
        imageViewAppIcon.clipsToBounds = true
        
        return imageViewAppIcon
        
    }()
    
    
    let titleLabel: UILabel = {
        
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.font = UIFont(name: "Poppins-Bold", size: 22.0)
        labelText.textColor = appColor
        labelText.textAlignment = .center
        labelText.numberOfLines = 1
        labelText.adjustsFontSizeToFitWidth = true
        
        return labelText
        
    }()
    
    
    let starRatingView = SwiftyStarRatingView()
    
    
    let rateButton: UIButton = {
        
        let buttonRate = UIButton()
        buttonRate.backgroundColor = appColor
        buttonRate.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 18.0)
        buttonRate.setTitleColor(.white, for: .normal)
        buttonRate.setTitle(NSLocalizedString("UIAlertController.backButton", comment: ""), for: .normal)
        buttonRate.layer.cornerRadius = 12.0
        
        return buttonRate
        
    }()
    
    
    var isFunnelActive: Bool = true
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(hexString: "FFF2F2")
        self.layer.cornerRadius = 20.0
        
        
        
        self.addSubview(appIconImageView)
        appIconImageView.translatesAutoresizingMaskIntoConstraints = false
        appIconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30.0).isActive = true
        appIconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        appIconImageView.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        appIconImageView.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        
        
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.appIconImageView.bottomAnchor, constant: 8.0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0).isActive = true
        
        titleLabel.text = NSLocalizedString("ReviewAlertView.titleLabel.text", comment: "")
        
        
        
        //starRatingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        starRatingView.backgroundColor = UIColor.clear
        starRatingView.maximumValue = 5  // default is 5
        starRatingView.minimumValue = 0  // default is 0
        starRatingView.value = 0  // default is 0
        starRatingView.allowsHalfStars = false  // default is true
        starRatingView.tintColor = UIColor(red: 0.9294, green: 0.7059, blue: 0.1647, alpha: 1.0) /* #edb42a */
        starRatingView.addTarget(self, action: #selector(starRatingViewValueChanged), for: .valueChanged)
        
        
        
        self.addSubview(starRatingView)
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        starRatingView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12.0).isActive = true
        starRatingView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        //starRatingView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0).isActive = true
        //starRatingView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10.0).isActive = true
        starRatingView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        starRatingView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        
        
        self.addSubview(rateButton)
        rateButton.translatesAutoresizingMaskIntoConstraints = false
        rateButton.topAnchor.constraint(equalTo: self.starRatingView.bottomAnchor, constant: 36.0).isActive = true
        rateButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        rateButton.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
        rateButton.widthAnchor.constraint(equalToConstant: 230.0).isActive = true
        
        rateButton.isHidden = true
        
    }
    
    
    @objc func starRatingViewValueChanged() {
        
        if self.isFunnelActive == true {
            
            if starRatingView.value == 0 {
                
                rateButton.isHidden = true
                
            } else if starRatingView.value <= 3 {
                
                rateButton.isHidden = false
                rateButton.setTitle(NSLocalizedString("ReviewAlertView.contactUs", comment: ""), for: .normal)
                
            } else {
                
                rateButton.isHidden = false
                rateButton.setTitle(NSLocalizedString("ReviewAlertView.rateUs", comment: ""), for: .normal)
                
            }
            
        } else {
            
            if starRatingView.value == 0 {
                
                rateButton.isHidden = true
                
            } else {
                
                rateButton.isHidden = false
                rateButton.setTitle(NSLocalizedString("ReviewAlertView.rateUs", comment: ""), for: .normal)
                
            }
            
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
