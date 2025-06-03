//
//  CustomNavigationBar.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-11.
//

import Foundation
import UIKit

class CustomNavigationBar: UIView {
    
     let titleLabel: UILabel
    private let leftButton: UIButton
     let rightButton: UIButton

    var leftButtonTapped: (() -> Void)?
    var rightButtonTapped: (() -> Void)?

    init(leftImage: UIImage? = nil, titleString: String? = nil, rightImage: UIImage? = nil, Font: CGFloat? = 20) {
        self.leftButton = UIButton(type: .custom)
        self.rightButton = UIButton(type: .custom)
        self.titleLabel = UILabel()
        super.init(frame: .zero)

        if let leftImage = leftImage {
            configureLeftButton(leftImage)
            addSubview(leftButton)
            // Button Animation
            leftButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
            leftButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
            leftButton.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
            leftButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                leftButton.widthAnchor.constraint(equalToConstant: 44),
                leftButton.heightAnchor.constraint(equalToConstant: 44),
            ])
        }
        
        if let rightImage = rightImage {
            configureRightButton(rightImage)
            addSubview(rightButton)
            // Button Animation
            rightButton.addTarget(self, action: #selector(touchDownButtonAction(_:)), for: .touchDown)
            rightButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpOutside)
            rightButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
            rightButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                rightButton.widthAnchor.constraint(equalToConstant: 44),
                rightButton.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
        
        if let titleString = titleString, titleString != "" {
            titleLabel.text = titleString
            titleLabel.font = UIFont.myBoldSystemFont(ofSize: Font ?? 20)
            titleLabel.textColor = .white//appColor
            titleLabel.textAlignment = .center
            addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLeftButton(_ image: UIImage?) {
        leftButton.setImage(image, for: .normal)
    }

    private func configureRightButton(_ image: UIImage?) {
        rightButton.setImage(image, for: .normal)
    }

    @objc private func leftButtonAction() {
        leftButton.showAnimation {
            self.leftButtonTapped?()
        }
    }

    @objc private func rightButtonAction() {
        rightButton.showAnimation {
            self.rightButtonTapped?()
        }
    }
}


