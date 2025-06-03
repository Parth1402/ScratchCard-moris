//
//  ActivityTableViewCell.swift
//  Scratch Adventure
//
//  Created by USER on 28/04/25.
//

import UIKit
import AlignedCollectionViewFlowLayout

class ActivityTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private var stylelengthArray = [String]()
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    var SelectedCell = 0
    var isNoteFilled = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16.pulse2Font())
        return label
    }()
    
    private let buttonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false // ⛔ Important: Disable scrolling
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    var isFieldChanged: (() -> Void)?
    var isAddActivity: (() -> Void)?
    
    private var selectedIndex: [IndexPath] = []
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(buttonContainerView)
        buttonContainerView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NoteTagesCollectionViewCell.self, forCellWithReuseIdentifier: "NoteTagesCollectionViewCell")
        collectionView.register(AddActivityCountCollectionViewCell.self, forCellWithReuseIdentifier: "AddActivityCountCollectionViewCell")
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DeviceSize.isiPadDevice ? 20 : 0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            buttonContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            buttonContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
        ])
        
        // Create the height constraint for the collection view and activate it
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionViewHeightConstraint?.isActive = true
    }
    
    func configure(withTitle title: String, Array array: [String], isNotefilled:Bool, index:Int) {
        self.isNoteFilled = isNotefilled
        self.titleLabel.text = title
        self.stylelengthArray = array
        SelectedCell = index
        collectionView.reloadData()
        
        // Ensure layout is updated after reload
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.layoutIfNeeded()
            let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.collectionViewHeightConstraint?.constant = height
            
            // Important: Ask the cell to layout itself again after the height change
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    
    
    
}

// MARK: - UICollectionViewDelegate, DataSource

extension ActivityTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isNoteFilled {
            return stylelengthArray.count 
        }else {
            return stylelengthArray.count + 1
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        if isNoteFilled {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteTagesCollectionViewCell", for: indexPath) as? NoteTagesCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let title = stylelengthArray[indexPath.item]
            cell.setupUI(headlineTitle: title)
            cell.setSelectedAppearance(true)
            return cell
        }else {
            if indexPath.item < stylelengthArray.count {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteTagesCollectionViewCell", for: indexPath) as? NoteTagesCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                let title = stylelengthArray[indexPath.item]
                cell.setupUI(headlineTitle: title)
              //  cell.setSelectedAppearance(selectedIndex == indexPath)
                cell.setSelectedAppearance(selectedIndex.contains(indexPath) == true)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddActivityCountCollectionViewCell", for: indexPath) as! AddActivityCountCollectionViewCell
                
                cell.configure(addText: SelectedCell == 0 ? "Add activities" : "")
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !isNoteFilled {
            if indexPath.item == stylelengthArray.count {
                isAddActivity?()
                
            } else {
                let previousIndex = selectedIndex
                // Toggling selection
                if let index = selectedIndex.firstIndex(of: indexPath) {
                    selectedIndex.remove(at: index) // Deselect
                } else {
                    selectedIndex.append(indexPath) // Select
                }
                collectionView.reloadItems(at: [indexPath])
                
                if let action = self.isFieldChanged {
                    action()
                }
            }
        }
        
    }
    
}
