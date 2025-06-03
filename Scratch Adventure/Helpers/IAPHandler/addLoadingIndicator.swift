//
//  addLoadingIndicator.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 14.12.21.
//

import Foundation
import UIKit


extension UIViewController {
    
    //let loadingIndicator = LoadingIndicatorHUD()
    //var isLoadingIndicatorAdded: Bool = false
    
    var isLoadingIndicatorAdded: Bool {
        get {
            return self.isLoadingIndicatorAdded
        }
        set(newValue) {
            self.isLoadingIndicatorAdded = newValue
        }
    }
    
    func addLoadingIndicator() {
        
        print("addLoadingIndicator")
        
        let myViews = self.view.subviews.filter{$0 is LoadingIndicatorHUD}
        if myViews.count == 0 {
            
            let loadingIndicator = LoadingIndicatorHUD()
            loadingIndicator.loadingLabel.text = NSLocalizedString("LoadingIndicatorHUD.loadingLabel.text", comment: "")
            
            self.view.addSubview(loadingIndicator)
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = true
            loadingIndicator.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
            loadingIndicator.heightAnchor.constraint(equalToConstant: 130.0).isActive = true
            
            //isLoadingIndicatorAdded = true
            
            // Animate Loading Indicator Appearance
            loadingIndicator.alpha = 0.0
            UIView.animate(withDuration: 0.35) {
                loadingIndicator.alpha = 1.0
            } completion: { (success) in
                
            }
            
        }
        
    }
    
    
    func removeLoadingIndicator() {
        
        print("removeLoadingIndicator")
        
        let myViews = self.view.subviews.filter{$0 is LoadingIndicatorHUD}
        for removeView in myViews {
            
            // Animate Loading Indicator Dismiss
            removeView.alpha = 1.0
            UIView.animate(withDuration: 0.4) {
                removeView.alpha = 0.0
            } completion: { (success) in
                removeView.removeFromSuperview()
            }
            
        }
        
    }
    
}
