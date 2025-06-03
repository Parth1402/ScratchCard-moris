//
//  AddCustomActivityViewController.swift
//  Scratch Adventure
//
//  Created by USER on 20/05/25.
//

import UIKit

class AddCustomActivityViewController: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    
    var  ActivityArray = [String]()
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
    
    var ActivityText: UITextField = {
        let TextField = UITextField()
        TextField.translatesAutoresizingMaskIntoConstraints = false

        TextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Activity",
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.5)
            ]
        )

        TextField.font = UIFont.mySystemFont(ofSize: 16)
        TextField.textColor = UIColor.white
        TextField.layer.borderWidth = 0.2
        TextField.layer.borderColor = UIColor.white.cgColor
        TextField.layer.cornerRadius = 20

        // Add left padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        TextField.leftView = paddingView
        TextField.leftViewMode = .always

        return TextField
    }()

    
    var AddButton: UIButton = {
        let Button = UIButton()
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.setTitle("+", for: .normal)
        Button.setTitleColor(.white, for: .normal)
        Button.titleLabel?.font = UIFont.myBoldSystemFont(ofSize: 22)
        Button.layer.cornerRadius = 22
        Button.backgroundColor = UIColor(hexString: "9A03D0")?.withAlphaComponent(0.24)
        Button.clipsToBounds = true
        return Button
    }()
    
    var selectedIndices: [Int] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setUpSearchBar()
   
        self.view.setUpBackground()
        self.view.addSubview(ContentContainer)

        
        
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
                ContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }
        setupTextfield()
        setupNextButton()
        
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
            SearchbarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            SearchbarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
            titleString: "Add activities",
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
    
    func setupTextfield() {
        ContentContainer.addSubview(ActivityText)
        NSLayoutConstraint.activate([
            ActivityText.topAnchor.constraint(equalTo: ContentContainer.topAnchor, constant: 30),
            ActivityText.heightAnchor.constraint(equalToConstant: 50),
            ActivityText.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor,constant: 16),
            ActivityText.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor,constant: -16),
        ])
    }
    
    func setupNextButton() {
        ContentContainer.addSubview(AddButton)
        AddButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            AddButton.topAnchor.constraint(equalTo: ActivityText.bottomAnchor, constant: 16),
            AddButton.heightAnchor.constraint(equalToConstant: 44),
            AddButton.widthAnchor.constraint(equalToConstant: 44),
            AddButton.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor,constant: 16),
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
        
        guard let activity = ActivityText.text?.trimmingCharacters(in: .whitespacesAndNewlines), !activity.isEmpty else {
             let alert = UIAlertController(title: "Empty Activity", message: "Please enter an activity.", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default))
             present(alert, animated: true)
             return
         }
    
        ActivityArray.append(activity)
            ActivityManager.shared.saveActivities(ActivityArray)
            
            self.dismiss(animated: true)
    }
}


extension AddCustomActivityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            filteredPositions = allPositions
//        } else {
//            filteredPositions = allPositions.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//        }
    }
}
