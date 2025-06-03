//
//  LocationTableViewCell.swift
//  Scratch Adventure
//
//  Created by USER on 01/05/25.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    private let topStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear


        // Name Label
        nameLabel.font = UIFont.mySystemFont(ofSize: 14)
        nameLabel.textColor = .white

        // Address Label
        addressLabel.font = UIFont.mySystemFont(ofSize: 13)
        addressLabel.textColor = .white.withAlphaComponent(0.6)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false

        // Stack View Setup
        topStackView.axis = .horizontal
        topStackView.spacing = 10
        topStackView.alignment = .center
        topStackView.translatesAutoresizingMaskIntoConstraints = false

            topStackView.addArrangedSubview(nameLabel)
    
       

        // Add to content view
        contentView.addSubview(topStackView)
        contentView.addSubview(addressLabel)

        // Layout
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            addressLabel.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 4),
            addressLabel.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor),
            addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(nameLabe : String, addressLabe : String ) {
        
            topStackView.addArrangedSubview(nameLabel)
   
       

        // Add to content view
        contentView.addSubview(topStackView)
        contentView.addSubview(addressLabel)

        // Layout
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            addressLabel.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 4),
            addressLabel.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor),
            addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        
    }
}

class RecentLocationTableViewCell: UITableViewCell {
    let nameLabel = UILabel()
    let thumbnailImageView = UIImageView()
    private let topStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        // Image View Setup
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.image = UIImage(named: "ic_mapPin")
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true

        // Name Label
        nameLabel.font = UIFont.mySystemFont(ofSize: 14)
        nameLabel.textColor = .white

        // Stack View Setup
        topStackView.axis = .horizontal
        topStackView.spacing = 10
        topStackView.alignment = .center
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
       
            topStackView.addArrangedSubview(thumbnailImageView)
            topStackView.addArrangedSubview(nameLabel)
     
       

        // Add to content view
        contentView.addSubview(topStackView)

        // Layout
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            topStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(nameLabe : String, addressLabe : String ) {
        
            topStackView.addArrangedSubview(thumbnailImageView)
            topStackView.addArrangedSubview(nameLabel)
       
       

        // Add to content view
        contentView.addSubview(topStackView)

        // Layout
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            topStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        
    }
}
