//
//  AddLocationItemCell.swift
//  Scratch Adventure
//
//  Created by USER on 22/05/25.
//

import UIKit

class AddLocationItemCell: UITableViewCell {
    
    static let identifier = "AddLocationItemCell"
    
    private let gradientLayer = CAGradientLayer()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    let radioButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_circle"), for: .normal)
        button.setImage(UIImage(named: "ic_filled_circle"), for: .selected)
        button.tintColor = .white
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.image = UIImage(named: "ic_addLocation_BG")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
      
        containerView.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
     
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
             backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
             backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
             backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
  
        
      //  setupGradientBackground()
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(radioButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            radioButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            radioButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: 24),
            radioButton.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: LocationItem) {
        titleLabel.text = item.name
        radioButton.isSelected = item.isSelected
    }
    
    private func setupGradientBackground() {
        gradientLayer.colors = [
            UIColor(hexString: "AF0E78")?.withAlphaComponent(0.4).cgColor ?? UIColor.clear.cgColor,
            UIColor(hexString: "9A03D0")?.withAlphaComponent(0.4).cgColor ?? UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 16
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        radioButton.isSelected = false
    }
}
