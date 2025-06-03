//
//  AddPositionViewController.swift
//  Scratch Adventure
//
//  Created by USER on 19/05/25.
//

import UIKit

struct AddPosition: Codable, Equatable {
    let imageName: String
    let name: String
}


class AddPositionViewController: UIViewController {

    var customNavBarView: CustomNavigationBar?

    var isSearching = false

    var Searchbar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        return searchBar
    }()

    var ContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var SearchbarContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.mySystemFont(ofSize: 16)
        cancelButton.setTitleColor(.white, for: .normal)
        return cancelButton
    }()

    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let itemWidth = DeviceSize.isiPadDevice ?  (UIScreen.main.bounds.width - 80) / 5 : (UIScreen.main.bounds.width - 48) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    var nextButton: UIButton = {
        let Button = UIButton()
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.setTitle("Next", for: .normal)
        Button.setTitleColor(.white, for: .normal)
        Button.titleLabel?.font = UIFont.myBoldSystemFont(ofSize: 22)
        Button.layer.cornerRadius = 15
        Button.backgroundColor = UIColor(named: "Violet") ?? .systemPurple
        Button.clipsToBounds = true
        return Button
    }()
    
    var selectedIndices: [Int] = []
    
   
    var allPositions: [AddPosition] = []
    var filteredPositions: [AddPosition] = []
    
    var selectedPositions: [AddPosition] = []

    let positionsImage = ["position_sample", "position_sample", "position_sample", "position_sample", "position_sample", "position_sample", "position_sample", "position_sample", "position_sample", "position_sample"]

    let positionsName = ["Position name A", "Position name B", "Position name C", "Position name D", "Position name E", "Position name F", "Position name G", "Position name H", "Position name I", "Position name J"]

  
    var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpNavigationBar()
        setUpSearchBar()
        setupCollectionView()
        setupNextButton()
        self.view.setUpBackground()
        self.view.addSubview(ContentContainer)
        
      
        
        
        allPositions = zip(positionsImage, positionsName).map {
              AddPosition(imageName: $0.0, name: $0.1)
          }
        
        filteredPositions = allPositions
        
        
        selectedIndices = filteredPositions.enumerated()
            .filter { selectedPositions.contains($0.element) }
            .map { $0.offset }
        
        
        print("Selected Indices: \(selectedIndices)")


        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                ContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                ContentContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80),
                ContentContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
                ContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                ContentContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                ContentContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                ContentContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                ContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }

        SearchbarContainer.isHidden = true
    }

    func setUpSearchBar() {
        view.addSubview(SearchbarContainer)
        SearchbarContainer.addSubview(Searchbar)
        SearchbarContainer.addSubview(cancelButton)
        
        Searchbar.placeholder = "Search"
        Searchbar.delegate = self
        Searchbar.translatesAutoresizingMaskIntoConstraints = false
        Searchbar.backgroundImage = UIImage()
        Searchbar.searchTextField.textColor = UIColor.white
        Searchbar.searchTextField.font = UIFont.mySystemFont(ofSize: 14)
        Searchbar.searchTextField.layer.cornerRadius = 10
        Searchbar.searchTextField.clipsToBounds = true
    
    if let textFieldd = Searchbar.searchTextField as? UITextField,
       let leftIconView = textFieldd.leftView as? UIImageView {
        leftIconView.tintColor = UIColor.white.withAlphaComponent(0.5)  // Change to your desired color
    }
    
    if let textField = Searchbar.value(forKey: "searchField") as? UITextField {
        textField.backgroundColor = UIColor(hex: "#9A03D0", alpha: 0.2)
        textField.borderStyle = .none
       
        
        textField.layer.backgroundColor = UIColor(hex: "#9A03D0", alpha: 0.2).cgColor
        
        // Gradient Background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hexString: "AF0E78")?.withAlphaComponent(0.2).cgColor,  // Pinkish with 40% opacity
            UIColor(hexString: "9A03D0")?.withAlphaComponent(0.2).cgColor   // Purple with 40% opacity
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 16
        gradientLayer.borderWidth = 0.2
        gradientLayer.borderColor = UIColor.white.cgColor

        DispatchQueue.main.async {
            gradientLayer.frame = textField.bounds
            textField.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        
        // Set placeholder text color
        textField.attributedPlaceholder = NSAttributedString(
             string: "Search",
             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
         )
    }

        Searchbar.delegate = self
        cancelButton.addTarget(self, action: #selector(toggleSearch), for: .touchUpInside)

        NSLayoutConstraint.activate([
            SearchbarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            SearchbarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: DeviceSize.isiPadDevice ?  38 : 0),
            SearchbarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: DeviceSize.isiPadDevice ?  -38 : 0),
            SearchbarContainer.heightAnchor.constraint(equalToConstant: 44),

            Searchbar.leadingAnchor.constraint(equalTo: SearchbarContainer.leadingAnchor, constant: 8),
            Searchbar.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -8),
            Searchbar.centerYAnchor.constraint(equalTo: SearchbarContainer.centerYAnchor),

            cancelButton.trailingAnchor.constraint(equalTo: SearchbarContainer.trailingAnchor, constant: -8),
            cancelButton.centerYAnchor.constraint(equalTo: SearchbarContainer.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }

    func setUpNavigationBar() {
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backIcon"),
            titleString: "Position",
            rightImage: UIImage(named: "ic_search")
        )

        guard let customNavBarView = customNavBarView else { return }

        customNavBarView.leftButtonTapped = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }

        customNavBarView.rightButtonTapped = { [weak self] in
            self?.toggleSearch()
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

    func setupCollectionView() {
        ContentContainer.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(PositionCell.self, forCellWithReuseIdentifier: "PositionCell")

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: ContentContainer.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: ContentContainer.bottomAnchor, constant: -88),
        ])
    }

    func setupNextButton() {
        ContentContainer.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: ContentContainer.bottomAnchor, constant: -30),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
        ])
    }

    @objc func toggleSearch() {
        isSearching.toggle()
        SearchbarContainer.isHidden = !isSearching
        customNavBarView?.isHidden = isSearching
        if !isSearching {
            Searchbar.text = ""
            Searchbar.resignFirstResponder()
        }
    }
    
    @objc func nextButtonTapped() {
        // Get selected items
        let selectedItems = selectedIndices.map { filteredPositions[$0] }

        if selectedItems.isEmpty {
            // Optionally show alert
            let alert = UIAlertController(title: "No Selection", message: "Please select at least one position.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            print("Selected positions: \(selectedItems)")
            
            let selected = selectedIndices.map { filteredPositions[$0] }

            PositionManager.shared.saveFilteredPositions(selected)
            
            self.dismiss(animated: true)
            

        }
    }
}

extension AddPositionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPositions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionCell", for: indexPath) as! PositionCell
        let isSelected = selectedIndices.contains(indexPath.item)
        cell.configure(imageName: filteredPositions[indexPath.item].imageName, name: filteredPositions[indexPath.item].name, isSelected: isSelected)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = selectedIndices.firstIndex(of: indexPath.item) {
            selectedIndices.remove(at: index)   // remove element at found index
        } else {
            selectedIndices.append(indexPath.item)  // insert the new selection
        }
        collectionView.reloadItems(at: [indexPath])
    }

}

extension AddPositionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          if searchText.isEmpty {
              filteredPositions = allPositions
          } else {
              filteredPositions = allPositions.filter { $0.name.lowercased().contains(searchText.lowercased()) }
          }
          collectionView.reloadData()
      }
}


class PositionCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        return titleLabel // ✅ Required
    }()
    
    var overlayView: UIView = {
        let overlayView = UIView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlayView.isHidden = true
        overlayView.layer.cornerRadius = overlayView.frame.width / 2
        overlayView.clipsToBounds = true
        return overlayView
    }()
    
    var checkmark: UIImageView = {
        let checkmark = UIImageView()
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.image = UIImage(named: "ic_Check")
        checkmark.isHidden = true
        return checkmark // ✅ Required
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
     
        imageView.layer.cornerRadius = self.frame.width / 2
        overlayView.layer.cornerRadius = self.frame.width / 2
        
        contentView.addSubview(imageView)
        contentView.addSubview(overlayView)
        overlayView.addSubview(checkmark)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            overlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),

            checkmark.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(imageName: String, name: String, isSelected: Bool) {
        imageView.image = UIImage(named: imageName)
        titleLabel.text = name
        overlayView.isHidden = !isSelected
        checkmark.isHidden = !isSelected
//        imageView.layer.borderColor = isSelected ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
//        imageView.layer.borderWidth = isSelected ? 2 : 0
    }
}
