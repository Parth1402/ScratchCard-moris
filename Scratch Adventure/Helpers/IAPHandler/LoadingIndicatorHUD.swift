//
//  LoadingIndicatorHUD.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 14.12.21.
//

import UIKit

class LoadingIndicatorHUD: UIView {
    
    let loadingLabel: UILabel = {
        
        let labelText = UILabel()
        labelText.backgroundColor = UIColor.clear
        labelText.textColor = UIColor.white
        labelText.font = UIFont(name: "Poppins-Bold", size: 18.0)
        labelText.textAlignment = .center
        labelText.adjustsFontSizeToFitWidth = true
        
        return labelText
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85) /* #000000 */
        self.layer.cornerRadius = 14.0
        
        
        
        self.addSubview(loadingLabel)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0).isActive = true
        loadingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0).isActive = true
        loadingLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0).isActive = true
        loadingLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        loadingLabel.text = NSLocalizedString("LoadingIndicatorHUD.loadingLabel.text", comment: "")
        
        
        
        // Spin config:
        let activityView = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityView.style = .large
        } else {
            // Fallback on earlier versions
        }
        activityView.assignColor(UIColor.white)
        
        self.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0).isActive = true
        activityView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        activityView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        activityView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        activityView.startAnimating()
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
