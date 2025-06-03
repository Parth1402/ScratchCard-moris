//
//  ButtonTapAnimationExtension.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-11.
//

import Foundation
import UIKit

public extension UIView {
    
    func showAnimation(isForError: Bool = false, _ completionBlock: @escaping () -> Void) {
        
        isUserInteractionEnabled = false
        
        if isForError {
            // Error
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }else{
            // Success
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
        
    }
    
    
    @objc func touchDownAnimation(_ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  (done) in
            self.isUserInteractionEnabled = true
        }
        
    }
    
    
    func touchUpAnimation(_ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        }) {  (done) in
            self.isUserInteractionEnabled = true
        }
        
    }
    
    func touchUpBounceAnimation(_ completionBlock: @escaping () -> Void) {
        
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.35,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseIn,
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        })  {  (done) in
            self.isUserInteractionEnabled = true
        }
    }
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        
        sender.touchDownAnimation {}
        
    }


    @objc func touchUpButtonAction(_ sender: UIButton) {
        
        sender.touchUpAnimation {}
        
    }
}
