//
//  MediaOption.swift
//  Scratch Adventure
//
//  Created by USER on 30/05/25.
//

import UIKit

// MARK: - Media Option Model
struct MediaOption {
    let title: String
}

class MediaOptionCell: UICollectionViewCell {
    static let identifier = "MediaOptionCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .white : .clear
            titleLabel.textColor = isSelected ? .black : .white
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 20
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with option: MediaOption) {
        titleLabel.text = option.title
    }
}
