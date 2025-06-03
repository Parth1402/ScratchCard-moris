//
//  PositionTableViewCell.swift
//  Scratch Adventure
//
//  Created by USER on 28/04/25.
//

import UIKit

class PositionTableViewCell: UITableViewCell {
        
        // MARK: - UI Elements
        
        private var  stylelengthArray = [String]()
        private var collectionViewHeightConstraint: NSLayoutConstraint?
        
        var SelectedCell = 0
        var isFilledNote = false
    
    let button1 = UIButton()
    let button2 = UIButton()
    
     var Positiondata: [AddPosition] = []//Array(repeating: UIImage(named: "NotePosition")!, count: 5) // Replace with your real images
        
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
        
    private let PositioncollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal                      // ✅ Horizontal scroll
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = 8
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)


        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true                      // ✅ Scrolling enabled
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let WhereTF: UITextField = {
        let TextField = UITextField()
        TextField.translatesAutoresizingMaskIntoConstraints = false
        TextField.placeholder = "Where"~
        TextField.font = .systemFont(ofSize: 14.pulse2Font())
        TextField.backgroundColor = UIColor.clear
        TextField.textColor = .white
        TextField.tintColor = .white
        return TextField
    }()
    
    let HowlongTF: UITextField = {
        let TextField = UITextField()
        TextField.translatesAutoresizingMaskIntoConstraints = false
        TextField.placeholder = "How long"~
        TextField.font = .systemFont(ofSize: 14.pulse2Font())
        TextField.backgroundColor = UIColor.clear
        TextField.textColor = .white
        TextField.tintColor = .white
        return TextField
    }()
    
    var isFieldChanged: (() -> Void)?
    
    var iswhereClick: (() -> Void)?
    
    var isAddPositionClick: (() -> Void)?
        


        
   
        private var selectedIndex: IndexPath?
    var maxVisible = 1
        
        
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
            buttonContainerView.addSubview(PositioncollectionView)
            
            PositioncollectionView.delegate = self
            PositioncollectionView.dataSource = self
            PositioncollectionView.register(PositionImageCollectionViewCell.self, forCellWithReuseIdentifier: "PositionImageCollectionViewCell")
            PositioncollectionView.register(PositionCountCollectionViewCell.self, forCellWithReuseIdentifier: "PositionCountCollectionViewCell")
            
            NSLayoutConstraint.activate([
               
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DeviceSize.isiPadDevice ? 20 : 8),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                
                buttonContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:  8),
                buttonContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
                buttonContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
                buttonContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
                
                PositioncollectionView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
                PositioncollectionView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 16),
                PositioncollectionView.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -16),
                //collectionView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
                PositioncollectionView.heightAnchor.constraint(equalToConstant: 60)
            ])
            collectionViewHeightConstraint = PositioncollectionView.heightAnchor.constraint(equalToConstant: 1)
            collectionViewHeightConstraint?.isActive = true
            
            
            let WhereLabel: UILabel = {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.textAlignment = .left
                label.text = "Where"~
                label.textColor = .white
                label.font = UIFont.boldSystemFont(ofSize: 16.pulse2Font())
                return label
            }()
            contentView.addSubview(WhereLabel)
            let WhereTFContainer = UIView()
            contentView.addSubview(WhereTFContainer)
            WhereTFContainer.backgroundColor = UIColor(hexString: "#9A03D0")?.withAlphaComponent(0.26)
            WhereTFContainer.dropShadow()
            WhereTFContainer.layer.cornerRadius = 12
            WhereTFContainer.translatesAutoresizingMaskIntoConstraints = false
            WhereTF.delegate = self
            
            WhereTFContainer.addSubview(WhereTF)
            NSLayoutConstraint.activate([
                WhereLabel.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 20),
                WhereLabel.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -15),
                WhereLabel.topAnchor.constraint(equalTo: PositioncollectionView.bottomAnchor, constant: DeviceSize.isiPadDevice ? 60 : 20),
                
                WhereTFContainer.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 20),
                WhereTFContainer.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -20),
                WhereTFContainer.topAnchor.constraint(equalTo: WhereLabel.bottomAnchor, constant: 8),
                WhereTFContainer.heightAnchor.constraint(equalToConstant: 60),
                
                WhereTF.leadingAnchor.constraint(equalTo: WhereTFContainer.leadingAnchor, constant: 15),
                WhereTF.trailingAnchor.constraint(equalTo: WhereTFContainer.trailingAnchor, constant: -15),
                WhereTF.topAnchor.constraint(equalTo: WhereTFContainer.topAnchor, constant: 0),
                WhereTF.bottomAnchor.constraint(equalTo: WhereTFContainer.bottomAnchor, constant: 0),
                
            ])
            button1.translatesAutoresizingMaskIntoConstraints = false
            WhereTFContainer.addSubview(button1)
            NSLayoutConstraint.activate([
                button1.centerYAnchor.constraint(equalTo: WhereTFContainer.centerYAnchor),
                button1.trailingAnchor.constraint(equalTo: WhereTFContainer.trailingAnchor, constant: -35),
                button1.widthAnchor.constraint(equalToConstant: 22), // Set fixed width
                button1.heightAnchor.constraint(equalToConstant: 22),
            ])
         
                            let WhereTFtapGesture = UITapGestureRecognizer(target: self, action: #selector(WhereTFTapped))
            WhereTF.addGestureRecognizer(WhereTFtapGesture)
            
            let HowlongLabel: UILabel = {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.textAlignment = .left
                label.text = "How long"~
                label.textColor = .white
                label.font = UIFont.boldSystemFont(ofSize: 16.pulse2Font())
                return label
            }()
            contentView.addSubview(HowlongLabel)
            let HowlongTFContainer = UIView()
            contentView.addSubview(HowlongTFContainer)
            HowlongTFContainer.backgroundColor = UIColor(hexString: "#9A03D0")?.withAlphaComponent(0.26)
            HowlongTFContainer.dropShadow()
            HowlongTFContainer.layer.cornerRadius = 12
            HowlongTFContainer.translatesAutoresizingMaskIntoConstraints = false
            HowlongTF.delegate = self
            HowlongTFContainer.addSubview(HowlongTF)
            NSLayoutConstraint.activate([
                HowlongLabel.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 20),
                HowlongLabel.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -15),
                HowlongLabel.topAnchor.constraint(equalTo: WhereTFContainer
                    .bottomAnchor, constant: 20),
                
                HowlongTFContainer.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 20),
                HowlongTFContainer.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -20),
                HowlongTFContainer.topAnchor.constraint(equalTo: HowlongLabel.bottomAnchor, constant: 8),
                HowlongTFContainer.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor, constant: -15),
                HowlongTFContainer.heightAnchor.constraint(equalToConstant: 60),
                
                HowlongTF.leadingAnchor.constraint(equalTo: HowlongTFContainer.leadingAnchor, constant: 15),
                HowlongTF.trailingAnchor.constraint(equalTo: HowlongTFContainer.trailingAnchor, constant: -15),
                HowlongTF.topAnchor.constraint(equalTo: HowlongTFContainer.topAnchor, constant: 0),
                HowlongTF.bottomAnchor.constraint(equalTo: HowlongTFContainer.bottomAnchor, constant: 0),
            ])
            


            button2.translatesAutoresizingMaskIntoConstraints = false
            HowlongTFContainer.addSubview(button2)
            NSLayoutConstraint.activate([
                button2.centerYAnchor.constraint(equalTo: HowlongTFContainer.centerYAnchor),
                button2.trailingAnchor.constraint(equalTo: HowlongTFContainer.trailingAnchor, constant: -35),
                button2.widthAnchor.constraint(equalToConstant: 22),
                button2.heightAnchor.constraint(equalToConstant: 22),
            ])
    
            
                            let HowlongTFtapGesture = UITapGestureRecognizer(target: self, action: #selector(HowlongTFTapped))
            HowlongTF.addGestureRecognizer(HowlongTFtapGesture)
            

        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            PositioncollectionView.layoutIfNeeded()
            collectionViewHeightConstraint?.constant = 60//collectionView.collectionViewLayout.collectionViewContentSize.height
        }

    func configure(withTitle title: String, Array array: [String],isfilledNote:Bool) {
        
        let locationItemdata = LocationManager.shared.RecentlyMarkedloadLocations()
        
        WhereTF.text = locationItemdata.first?.name ?? ""

        self.isFilledNote = isfilledNote
            self.titleLabel.text = title
        
        // Set or remove image based on isfilledNote
            button1.setImage(isfilledNote ? nil : UIImage(named: "downArrowIcon"), for: .normal)
            button2.setImage(isfilledNote ? nil : UIImage(named: "downArrowIcon"), for: .normal)
        
            self.stylelengthArray.append("+")
        maxVisible = Positiondata.count - 1
        PositioncollectionView.reloadData()
            
       
            
            // Ensures collectionView height updates after data reload
        PositioncollectionView.performBatchUpdates(nil) { [weak self] _ in
                self?.PositioncollectionView.layoutIfNeeded()
                self?.collectionViewHeightConstraint?.constant = 60//self.collectionView.collectionViewLayout.collectionViewContentSize.height
                self?.invalidateIntrinsicContentSize()
                
    //            // Important if your cell uses automatic height
    //            self.superview?.setNeedsLayout()
    //            self.superview?.layoutIfNeeded()
            }
        }
    
    @objc func WhereTFTapped() {
//        RegionTF.showAnimation {
//        }
            if let action = iswhereClick {
                action()
            
        }
    }
    
    @objc func HowlongTFTapped() {
        HowlongTF.showAnimation {
        }
    }
    
    @objc func dismissPicker() {
        self.contentView.endEditing(true)
    }

        
    }

    // MARK: - UICollectionViewDelegate, DataSource

    extension PositionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if  isFilledNote {
                return Positiondata.count
            }else {
                return Positiondata.count + 1
            }
           
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if isFilledNote {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionImageCollectionViewCell", for: indexPath) as! PositionImageCollectionViewCell
                cell.configure(with: Positiondata[indexPath.item].imageName)
                return cell
            } else {
                if indexPath.item < Positiondata.count {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionImageCollectionViewCell", for: indexPath) as! PositionImageCollectionViewCell
                    cell.configure(with: Positiondata[indexPath.item].imageName)
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionCountCollectionViewCell", for: indexPath) as! PositionCountCollectionViewCell
                    cell.configure()
                    return cell
                }
            }
        }

        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if !isFilledNote && indexPath.item == Positiondata.count {
                isAddPositionClick?()
            }
        }

    }


extension PositionTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //textField.showAnimation {}
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        

        if let action = self.isFieldChanged {
            
//            if textField == RegionTF {
//                if textField.text != NameGenerateManager.shared.Region {
//                    NameGenerateDataBeforeSaving.RegionName = textField.text ?? ""
//                    NameGenerateDataBeforeSaving.isRegionNameChanged = true
//                } else {
//                    NameGenerateDataBeforeSaving.isRegionNameChanged = false
//                }
//                action()
//            }
//
//            if textField == LastNameTF {
//                if textField.text != NameGenerateManager.shared.LastName {
//                    NameGenerateDataBeforeSaving.LastName = textField.text ?? ""
//                    NameGenerateDataBeforeSaving.isLastNameChanged = true
//                } else {
//                    NameGenerateDataBeforeSaving.isLastNameChanged = false
//                }
//                action()
//            }
            
        }
        
    }
}
