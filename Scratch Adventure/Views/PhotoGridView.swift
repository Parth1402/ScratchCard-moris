//
//  PhotoGridView.swift
//  Scratch Adventure
//
//  Created by USER on 30/04/25.
//


import UIKit

class PhotoGridView: UIView {
    
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        titleLabel.text = "Photos"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(stackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 120),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setImages(_ images: [UIImage]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let maxCount = min(3, images.count)
        
        for i in 0..<maxCount {
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.clipsToBounds = true
            containerView.layer.cornerRadius = 16
            containerView.backgroundColor = .clear
            
            let imageView = UIImageView(image: images[i])
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 16
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            containerView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ])
            
            // Apply blur overlay only on the third image if more than 3
            //     if i == 2 && images.count > 3 {
            //                let blurEffect = UIBlurEffect(style: .light)
            //                let blurView = UIVisualEffectView(effect: blurEffect)
            //                blurView.layer.cornerRadius = 16
            //                blurView.clipsToBounds = true
            //                blurView.translatesAutoresizingMaskIntoConstraints = false
            
            let dimmingView = UIView()
            dimmingView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            dimmingView.layer.cornerRadius = 16
            dimmingView.clipsToBounds = true
            dimmingView.translatesAutoresizingMaskIntoConstraints = false
            
            let label = PaddingLabel()
            label.text = "\(images.count - 3)+"
            label.textColor = .white
            label.font = UIFont.mymediumSystemFont(ofSize: 11)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.layer.cornerRadius = 15
            label.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            label.textAlignment = .center
            label.clipsToBounds = true
            
            containerView.addSubview(dimmingView)
            
            if i == 2 && images.count > 3 {
                
                containerView.addSubview(label)
                
                NSLayoutConstraint.activate([
                    
                    dimmingView.topAnchor.constraint(equalTo: imageView.topAnchor),
                    dimmingView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
                    dimmingView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                    dimmingView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                    
                    label.trailingAnchor.constraint(equalTo: dimmingView.trailingAnchor, constant: -8),
                    label.bottomAnchor.constraint(equalTo: dimmingView.bottomAnchor, constant: -8),
                    label.heightAnchor.constraint(equalToConstant: 30),
                    label.widthAnchor.constraint(equalToConstant: 30)
                ])
                
            }else {
                NSLayoutConstraint.activate([
                    
                    dimmingView.topAnchor.constraint(equalTo: imageView.topAnchor),
                    dimmingView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
                    dimmingView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                    dimmingView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                ])
            }
            
            
            // }
            
            stackView.addArrangedSubview(containerView)
        }
    }
}

class PaddingLabel: UILabel {
    var insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + insets.left + insets.right,
                      height: size.height + insets.top + insets.bottom)
    }
}
