//
//  NoteTagesCollectionViewCell.swift
//  Scratch Adventure
//
//  Created by USER on 23/04/25.
//

import UIKit

class NoteTagesCollectionViewCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 12)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(hexString: "9A03D0")?.withAlphaComponent(0.24)
        contentView.layer.cornerRadius = 16
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.borderWidth = 0
        contentView.clipsToBounds = false
        contentView.dropShadow()
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(headlineTitle: String) {
        titleLabel.text = headlineTitle
    }
    
    func setSelectedAppearance(_ selected: Bool) {
        if selected {
            // Apply border color and width
            
            // Remove existing gradient layers
            contentView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

            // Create a new gradient layer
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = contentView.bounds // Ensure it covers the entire contentView
            gradientLayer.cornerRadius = contentView.layer.cornerRadius // Apply corner radius

            gradientLayer.colors = [
                UIColor(hex: "#A249E5").cgColor,
                UIColor(hex: "#6524FF").cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5) // left middle
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)   // right middle

            // Insert the gradient layer at the bottom of the layer stack
            contentView.layer.insertSublayer(gradientLayer, at: 0)
        } else {
            // Remove border and gradient when unselected
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.borderWidth = 0
            
            // Remove gradient layer if it exists
            contentView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Update the gradient layer frame if needed (in case the bounds of the contentView change)
        if let gradientLayer = contentView.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = contentView.bounds
        }
    }
}

class ActivityCollectionViewCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.mymediumSystemFont(ofSize: DeviceSize.isiPadDevice ? 16 : 16)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(hexString: "9A03D0")?.withAlphaComponent(0.24)
        contentView.layer.cornerRadius = 16
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.borderWidth = 0
        contentView.clipsToBounds = false
        contentView.dropShadow()
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(headlineTitle: String) {
        titleLabel.text = headlineTitle
    }
    
    func setSelectedAppearance(_ selected: Bool) {
        if selected {
            // Apply border color and width
            
            // Remove existing gradient layers
            contentView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

            // Create a new gradient layer
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = contentView.bounds // Ensure it covers the entire contentView
            gradientLayer.cornerRadius = contentView.layer.cornerRadius // Apply corner radius

            gradientLayer.colors = [
                UIColor(hex: "#A249E5").cgColor,
                UIColor(hex: "#6524FF").cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5) // left middle
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)   // right middle

            // Insert the gradient layer at the bottom of the layer stack
            contentView.layer.insertSublayer(gradientLayer, at: 0)
        } else {
            // Remove border and gradient when unselected
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.borderWidth = 0
            
            // Remove gradient layer if it exists
            contentView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Update the gradient layer frame if needed (in case the bounds of the contentView change)
        if let gradientLayer = contentView.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = contentView.bounds
        }
    }
}


class NoteImageCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 16 // Half of 22 for perfect circle
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.purple.cgColor
        iv.layer.borderWidth = 3
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 32),
            imageView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
}


import UIKit

class NoteCountCollectionViewCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = UIColor.clear
        label.textAlignment = .left
        label.font = UIFont.mySystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40), // 🔥 Leading spacing
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(count: String) {
        label.text = "+\(count)"
    }
}


class PositionImageCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 22 // Half of 44 for circle
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.purple.cgColor
        iv.layer.borderWidth = 0.5
        iv.contentMode = .scaleAspectFit
        iv.layer.backgroundColor = UIColor.white.cgColor
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 44),
            imageView.heightAnchor.constraint(equalToConstant: 44),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: String) {
        imageView.image = UIImage(named: image)
    }
}



class PositionCountCollectionViewCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = UIColor(hexString: "#9A03D0")?.withAlphaComponent(0.26)
        label.textAlignment = .center
        label.font = UIFont.mySystemFont(ofSize: 22)
        label.layer.cornerRadius = 22.5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), // 🔥 Leading spacing
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.heightAnchor.constraint(equalToConstant: 45),
            label.widthAnchor.constraint(equalToConstant: 45)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        label.text = "+"
    }
}


class ActivityCountCollectionViewCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = UIColor(hexString: "#9A03D0")?.withAlphaComponent(0.26)
        label.textAlignment = .center
        label.font = UIFont.mySystemFont(ofSize: 22)
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), // 🔥 Leading spacing
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.heightAnchor.constraint(equalToConstant: 35),
            label.widthAnchor.constraint(equalToConstant: 40)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        label.text = "+"
    }
}


class AddActivityCountCollectionViewCell: UICollectionViewCell {

    private let label: PaddingLabel = {
        let label = PaddingLabel()
        label.textColor = .white
        label.backgroundColor = UIColor(hexString: "#9A03D0")?.withAlphaComponent(0.26)
        label.textAlignment = .center
        label.font = UIFont.mymediumSystemFont(ofSize: 12)
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(addText: String) {
        label.text = "+ \(addText)"
    }
}

//class PaddingLabel: UILabel {
//    var insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
//
//    override func drawText(in rect: CGRect) {
//        super.drawText(in: rect.inset(by: insets))
//    }
//
//    override var intrinsicContentSize: CGSize {
//        let size = super.intrinsicContentSize
//        return CGSize(width: size.width + insets.left + insets.right,
//                      height: size.height + insets.top + insets.bottom)
//    }
//}
