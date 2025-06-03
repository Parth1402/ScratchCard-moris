//
//  PrivateVaultViewController.swift
//  Scratch Adventure
//
//  Created by USER on 26/05/25.
//

import UIKit
class PrivateVaultViewController: UIViewController {

    var customNavBarView: CustomNavigationBar?

    var ContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var infoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Violet")
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let iconImageView: UIImageView = {
          let imageView = UIImageView()
          imageView.image = UIImage(named: "ic_info")
          imageView.tintColor = .white
          imageView.translatesAutoresizingMaskIntoConstraints = false
          return imageView
      }()

      private let messageLabel: UILabel = {
          let label = UILabel()
          label.text = "This is your safe place where you can save your photos and videos."
          label.font = UIFont.mySystemFont(ofSize: 16)
          label.textColor = .white
          label.numberOfLines = 0
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()

      private let closeButton: UIButton = {
          let button = UIButton(type: .system)
          button.setImage(UIImage(named: "ic_close"), for: .normal)
          button.tintColor = .white
          button.translatesAutoresizingMaskIntoConstraints = false
          return button
      }()

    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5

        let availableWidth = UIScreen.main.bounds.width

        layout.itemSize = CGSize(width: availableWidth / 3 - 16, height: availableWidth / 3 - 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 8
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()



    var AddButton: UIButton = {
        let Button = UIButton()
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.setImage(UIImage(named: "ic_Plus_add"), for: .normal)
        Button.setTitleColor(.white, for: .normal)
        Button.layer.cornerRadius = 30
        Button.clipsToBounds = true
        return Button
    }()
    
    var emptyImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "img_empty_image")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var isVisible: Bool = true
    
    var collectionTopConstraint: NSLayoutConstraint?

    
    var selectedPositions = false

   // let privateImage = ["dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo", "dummyvideo"]
    
    //var privateImage = [MediaItem]()
    
    var privateImage: [MediaItem] = [] {
        didSet {
            emptyImageView.isHidden = !privateImage.isEmpty
        }
    }

  
    var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
        setUpNavigationBar()
        setupinfoContainer()
        setupCollectionView()
        setupAddButton()
        checkIfEmpty()
        self.view.setUpBackground()
        self.view.addSubview(ContentContainer)
        
        privateImage =  VaultDataManager.shared.fetchMediaArray()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(mediaUpdated),name: .mediaUpdated,object: nil
        )


        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                ContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                ContentContainer.widthAnchor.constraint(equalToConstant: 460),
                ContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                ContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                ContentContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                ContentContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                ContentContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                ContentContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        }
    }
    
    func checkIfEmpty() {
        emptyImageView.isHidden = !privateImage.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        privateImage =  VaultDataManager.shared.fetchMediaArray()
        checkIfEmpty()
        collectionView.reloadData()
    }
    
    @objc func mediaUpdated() {
        privateImage =  VaultDataManager.shared.fetchMediaArray()
        checkIfEmpty()
        collectionView.reloadData()
    }


    func setUpNavigationBar() {
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backIcon"),
            titleString: "Private vault",
            rightImage: UIImage(named: "ic_Eye")
        )

        guard let customNavBarView = customNavBarView else { return }

        customNavBarView.leftButtonTapped = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }

        customNavBarView.rightButtonTapped = { [weak self] in
            self?.toggleVisible()
        }

        view.addSubview(customNavBarView)
        customNavBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBarView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func setupinfoContainer(){
        
        ContentContainer.addSubview(infoContainer)
        ContentContainer.addSubview(emptyImageView)


        
        infoContainer.addSubview(iconImageView)
        infoContainer.addSubview(messageLabel)
        infoContainer.addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
                           NSLayoutConstraint.activate([
                            
                            emptyImageView.centerXAnchor.constraint(equalTo: ContentContainer.centerXAnchor),
                            emptyImageView.centerYAnchor.constraint(equalTo: ContentContainer.centerYAnchor),
                            emptyImageView.widthAnchor.constraint(equalToConstant: 200),
                            emptyImageView.heightAnchor.constraint(equalToConstant: 200),
                            
                            infoContainer.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
                            infoContainer.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
                            infoContainer.topAnchor.constraint(equalTo: ContentContainer.topAnchor, constant: 8),
                            
                            iconImageView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor, constant: 12),
                            iconImageView.topAnchor.constraint(equalTo: infoContainer.topAnchor,constant: 12),
                               iconImageView.widthAnchor.constraint(equalToConstant: 40)    ,
                               iconImageView.heightAnchor.constraint(equalToConstant: 40),

                            closeButton.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor, constant: -12),
                            closeButton.topAnchor.constraint(equalTo: infoContainer.topAnchor,constant: 12),
                               closeButton.widthAnchor.constraint(equalToConstant: 20),
                               closeButton.heightAnchor.constraint(equalToConstant: 20),

                               messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
                               messageLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -10),
                            messageLabel.topAnchor.constraint(equalTo: infoContainer.topAnchor, constant: 12),
                            messageLabel.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: -12)
                           ])
    }

    func setupCollectionView() {
        ContentContainer.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(PrivateImageCell.self, forCellWithReuseIdentifier: "PrivateImageCell")
        
        collectionTopConstraint = collectionView.topAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: 16)

        NSLayoutConstraint.activate([
            collectionTopConstraint!,
            collectionView.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: ContentContainer.bottomAnchor, constant: 1),
        ])
    }
    
    @objc func closeTapped() {
        infoContainer.removeFromSuperview()  // or set hidden if you want to reuse it

        // Update the top constraint
        collectionTopConstraint?.isActive = false
        collectionTopConstraint = collectionView.topAnchor.constraint(equalTo: ContentContainer.topAnchor, constant: 16)
        collectionTopConstraint?.isActive = true

        // Animate the layout change
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }


    func setupAddButton() {
        ContentContainer.addSubview(AddButton)
        AddButton.addTarget(self, action: #selector(AddButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            AddButton.bottomAnchor.constraint(equalTo: ContentContainer.bottomAnchor, constant: -30),
            AddButton.heightAnchor.constraint(equalToConstant: 60),
            AddButton.widthAnchor.constraint(equalToConstant: 60),
            AddButton.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
        ])
    }

    @objc func toggleVisible() {
        
        isVisible.toggle()
        
        let newImageName = isVisible ? "ic_Eye" : "Ic_eye_NotVisible"
            customNavBarView?.rightButton.setImage(UIImage(named: newImageName), for: .normal)
        
        collectionView.reloadData()
  
    }
    
    @objc func AddButtonTapped() {
        // Get selected items
        
        let sheetVC = ImagePickerBottomSheet()
        if let sheet = sheetVC.sheetPresentationController {
                // Define custom detents with specific identifiers
                let mediumDetentId = UISheetPresentationController.Detent.Identifier("mediumCustom")
                let mediumDetent = UISheetPresentationController.Detent.custom(identifier: mediumDetentId) { context in
                    return 170
                }
            sheet.detents = [mediumDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 20
        }
        present(sheetVC, animated: true)

 
    }
    
}

extension PrivateVaultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return privateImage.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrivateImageCell", for: indexPath) as! PrivateImageCell
      
        cell.configure(item: privateImage[indexPath.item], isSelected: isVisible)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let point = gesture.location(in: collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: point) {
            // Present the popup view
            let popupVC = DeletevaultImagePopupViewController()
            popupVC.Index = indexPath
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            present(popupVC, animated: true, completion: nil)
        }
    }


}
