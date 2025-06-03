//
//  AddActivityViewController.swift
//  Scratch Adventure
//
//  Created by USER on 20/05/25.
//

import UIKit
import AlignedCollectionViewFlowLayout

class AddActivityViewController: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    
    private var  ActivityArray = [String]()
    var filteredActivity: [String] = []
    private var selectedIndex: [IndexPath] = []
    
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
    
    private let collectionView: UICollectionView = {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false // ⛔ Important: Disable scrolling
        collectionView.backgroundColor = .clear
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ActivityArray = ["More oral sex", "In a bath", "Anal sex", "In a shower", "Role play","Threesome", "Threesome", "In a car", "Threesome", "Role play", "Role play","Role play", "Role play", "Anal sex", "Role play", "Role play", "In a car","In a car", "In a car", "In a shower", "Role play", "Role play"]
        
        ActivityManager.shared.saveActivities(ActivityArray)
        
      let  activitiesArr = ActivityManager.shared.loadSelectedActivities()
        
        selectedIndex = ActivityArray.enumerated()
            .filter { activitiesArr.contains($0.element) }
            .map { IndexPath(item: $0.offset, section: 0) }

        
        
        print("Selected Indices: \(selectedIndex)")

        setUpNavigationBar()
        setUpSearchBar()
        setupCollectionView()
        setupNextButton()
        self.view.setUpBackground()
        self.view.addSubview(ContentContainer)
        
        filteredActivity = ActivityArray
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        ActivityArray = ActivityManager.shared.loadActivities()
        filteredActivity = ActivityArray
        
        collectionView.reloadData()
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
            titleString: "Activities",
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
        
        collectionView.register(ActivityCollectionViewCell.self, forCellWithReuseIdentifier: "ActivityCollectionViewCell")
        collectionView.register(ActivityCountCollectionViewCell.self, forCellWithReuseIdentifier: "ActivityCountCollectionViewCell")
        
        
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
        let selectedItems = selectedIndex.map { filteredActivity[$0.row] }
        
        if selectedItems.isEmpty {
            // Optionally show alert
            let alert = UIAlertController(title: "No Selection", message: "Please select at least one position.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            print("Selected positions: \(selectedItems)")
            
            let selected = selectedIndex.map { filteredActivity[$0.row] }
            
            ActivityManager.shared.saveSelectedActivities(selected)
            
            self.dismiss(animated: true)
            
            
        }
    }
}

extension AddActivityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredActivity.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item < filteredActivity.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCollectionViewCell", for: indexPath) as! ActivityCollectionViewCell
            let title = filteredActivity[indexPath.item]
            
            cell.setupUI(headlineTitle: title)
            
            
          //  cell.setSelectedAppearance(selectedIndex == indexPath)
            cell.setSelectedAppearance(selectedIndex.contains(indexPath) == true)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCountCollectionViewCell", for: indexPath) as! ActivityCountCollectionViewCell
            cell.configure()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == filteredActivity.count {
   print("Add Custom Activity.....")
            
            let pickerVC = AddCustomActivityViewController()
                pickerVC.modalPresentationStyle = .fullScreen
            pickerVC.ActivityArray = ActivityArray
                self.present(pickerVC, animated: true)
            
        }else {
            let previousIndex = selectedIndex
            // Toggling selection
            if let index = selectedIndex.firstIndex(of: indexPath) {
                selectedIndex.remove(at: index) // Deselect
            } else {
                selectedIndex.append(indexPath) // Select
            }
            collectionView.reloadItems(at: [indexPath])
        }
       
        
    }
}

extension AddActivityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredActivity = ActivityArray
        } else {
            filteredActivity = ActivityArray.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }
}
