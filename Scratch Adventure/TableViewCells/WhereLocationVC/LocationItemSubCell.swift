//
//  LocationItemSubCell.swift
//  Scratch Adventure
//
//  Created by USER on 22/05/25.
//

import UIKit

class LocationItemSubCell: UITableViewCell {
    
    static let identifier = "LocationItemSubCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mySystemFont(ofSize: 15)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(radioButton)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            radioButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: 24),
            radioButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with Item: LocationItem) {
        titleLabel.text = Item.name
        radioButton.isSelected = Item.isSelected
    }
}

