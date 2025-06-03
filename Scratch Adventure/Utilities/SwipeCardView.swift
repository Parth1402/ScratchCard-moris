//
//  SwipeCardView.swift
//  Ovulio Baby
//
//  Created by USER on 14/04/25.
//

import Foundation
import UIKit

class SwipeCardView: UIView {
     let nameLabel = UILabel()
     let lastNameLabel = UILabel()
    
    // 💖 Heart icons
    let heartImageView = UIImageView(image: UIImage(named: "nameCardLike"))
    let brokenHeartImageView = UIImageView(image: UIImage(named: "nameCardDisLike"))

    init(firstName: String, lastName: String) {
        super.init(frame: .zero)
        setupView(firstName: firstName, lastName: lastName)
        setupHeartIcons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(firstName: String, lastName: String) {
        
       backgroundColor = .white
       layer.cornerRadius = 20

       layer.shadowColor = UIColor.darkGray.cgColor
       layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 0.4)
       layer.shadowRadius = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.4

       layer.masksToBounds = false
       translatesAutoresizingMaskIntoConstraints = false

       // nameLabel.text = firstName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nameLabel.textColor = appColor
        nameLabel.textAlignment = .center

     //   lastNameLabel.text = lastName
        lastNameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        lastNameLabel.textColor = appColor
        lastNameLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [nameLabel, lastNameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupHeartIcons() {
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        brokenHeartImageView.translatesAutoresizingMaskIntoConstraints = false

        heartImageView.alpha = 0
        brokenHeartImageView.alpha = 0

        addSubview(heartImageView)
        addSubview(brokenHeartImageView)

        NSLayoutConstraint.activate([
            heartImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            heartImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            heartImageView.widthAnchor.constraint(equalToConstant: 22),
            heartImageView.heightAnchor.constraint(equalToConstant: 22),

            brokenHeartImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            brokenHeartImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            brokenHeartImageView.widthAnchor.constraint(equalToConstant: 30),
            brokenHeartImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func applySwipeGesture(target: Any, action: Selector) {
        let panGesture = UIPanGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(panGesture)
    }
    
    func updateName(firstName: String, lastName: String, showLastName: Bool) {
        nameLabel.text = firstName
        lastNameLabel.text = showLastName ? lastName : ""
    }
}
