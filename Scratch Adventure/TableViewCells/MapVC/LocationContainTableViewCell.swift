//
//  LocationContainTableViewCell.swift
//  Scratch Adventure
//
//  Created by USER on 01/05/25.
//

import UIKit
import SwiftyStarRatingView

class LocationContainTableViewCell: UITableViewCell {
    static let identifier = "LocationContainTableViewCell"
    
    private var  stylelengthArray = [String]()
    
    private let images: [UIImage] = Array(repeating: UIImage(named: "homeScreenAvatar")!, count: 15) // Replace with your real images
    private let maxVisible = 10
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#0E1626")
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth  = 1
        
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let titleLabel : UILabel =  {
        let label = UILabel()
        label.font = .myBoldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let subtitleLabel : UILabel =  {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let dateLabel : UILabel =  {
        let label = UILabel()
        label.font = .myBoldSystemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    private let locationLabel : UILabel =  {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        return view
    }()
    
    private  let starRatingView : SwiftyStarRatingView = {
        let view = SwiftyStarRatingView()
        view.backgroundColor = .clear
        view.maximumValue = 5
        view.minimumValue = 0
        view.spacing = 4
        view.value = 3
        view.isEnabled = false
        view.tintColor = UIColor(hexString: "#FE9635")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let ratingLabel : UILabel =  {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let orgasmLabel : UILabel =  {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    //    private let collectionView: UICollectionView = {
    //        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
    //        layout.minimumInteritemSpacing = 8
    //        layout.minimumLineSpacing = 8
    //        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    //
    //        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    //        collectionView.translatesAutoresizingMaskIntoConstraints = false
    //        collectionView.isScrollEnabled = true // ⛔ Important: Disable scrolling
    //        collectionView.backgroundColor = .clear
    //        return collectionView
    //    }()
    
    private let AcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal                      // ✅ Horizontal scroll
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true                      // ✅ Scrolling enabled
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    private let OverlapingcollectionView: UICollectionView = {
        
        let layout = OverlappingFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumLineSpacing = -30 // Controls overlap
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false // ⛔ Important: Disable scrolling
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    
    //   private let tagsStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        [titleLabel, subtitleLabel, dateLabel, locationLabel, ratingLabel, orgasmLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .white
        }
        
        contentView.addSubview(containerView)
        [titleLabel, subtitleLabel, dateLabel, locationLabel,lineView, ratingLabel,starRatingView, orgasmLabel, AcollectionView, OverlapingcollectionView].forEach {
            containerView.addSubview($0)
        }
        
        AcollectionView.delegate = self
        AcollectionView.dataSource = self
        AcollectionView.register(NoteTagesCollectionViewCell.self, forCellWithReuseIdentifier: "NoteTagesCollectionViewCell")
        
        
        
        OverlapingcollectionView.dataSource = self
        OverlapingcollectionView.delegate = self
        OverlapingcollectionView.backgroundColor = .clear
        OverlapingcollectionView.showsHorizontalScrollIndicator = false
        OverlapingcollectionView.register(NoteImageCollectionViewCell.self, forCellWithReuseIdentifier: "NoteImageCollectionViewCell")
        OverlapingcollectionView.register(NoteCountCollectionViewCell.self, forCellWithReuseIdentifier: "NoteCountCollectionViewCell")
        
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.leadingAnchor, constant: -8),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: locationLabel.leadingAnchor, constant: -8),
            
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            locationLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            
            lineView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            lineView.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            lineView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            
            
            
            OverlapingcollectionView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 8),
            OverlapingcollectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -16),
            OverlapingcollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            //  OverlapingcollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            OverlapingcollectionView.heightAnchor.constraint(equalToConstant: 25),
            
            ratingLabel.topAnchor.constraint(equalTo: OverlapingcollectionView.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.heightAnchor.constraint(equalToConstant: 30), // adjust as needed
            
            starRatingView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            starRatingView.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 8),
            starRatingView.heightAnchor.constraint(equalToConstant: 30), // adjust as needed
            starRatingView.widthAnchor.constraint(equalToConstant: 90),  // adjust as needed
            
            
            
            orgasmLabel.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            orgasmLabel.leadingAnchor.constraint(equalTo: starRatingView.trailingAnchor, constant: 16),
            
            AcollectionView.topAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 8),
            AcollectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            AcollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            AcollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            AcollectionView.heightAnchor.constraint(equalToConstant: 40), // adjust as needed
            
        ])
        
        
    }
    
    func configure(title: String, subtitle: String, date: String, location: String, rating: Double, orgasms: Int, tags: [String], isHome:Bool) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        dateLabel.text = date
        
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(hexString: "#0E1626")
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        containerView.layer.borderWidth  = 1
        containerView.layer.cornerRadius = 16
        
        locationLabel.attributedText = createImageTextAttachmentText(imageName: "ic_navigate", text: location)
        
        ratingLabel.text = "\(rating)"
        
        starRatingView.value = rating
        orgasmLabel.attributedText = createImageWithTextAttachment(imageName: "ic_orgasm", text: "\(orgasms)")
        
        stylelengthArray = tags
        AcollectionView.reloadData()
        OverlapingcollectionView.reloadData()
        
        
        
    }
}

// MARK: - UICollectionViewDelegate, DataSource

extension LocationContainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == AcollectionView {
            return stylelengthArray.count
        }else {
            return min(images.count, maxVisible) + (images.count > maxVisible ? 1 : 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == AcollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteTagesCollectionViewCell", for: indexPath) as? NoteTagesCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let title = stylelengthArray[indexPath.item]
            cell.setupUI(headlineTitle: title)
            
            // cell.setSelectedAppearance(selectedIndex == indexPath)
            
            return cell
        }else {
            if indexPath.item < maxVisible {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteImageCollectionViewCell", for: indexPath) as! NoteImageCollectionViewCell
                cell.configure(with: images[indexPath.item])
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCountCollectionViewCell", for: indexPath) as! NoteCountCollectionViewCell
                let extraCount = images.count - maxVisible
                cell.configure(count: "\(extraCount)")
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}
