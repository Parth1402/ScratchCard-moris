//
//  PopupViewController.swift
//  Scratch Adventure
//
//  Created by USER on 27/05/25.
//


import UIKit

class DeletevaultImagePopupViewController: UIViewController {
    
    private let backgroundView = UIView()
    private let popupView = UIView()
    
     var Index = IndexPath()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Delete this media from your camera roll?"
        label.font = UIFont.myBoldSystemFont(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "It will be saved in scratch adventure\nprivate vault and will be protected"
        label.font = UIFont.mySystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.myBoldSystemFont(ofSize: 16)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.myBoldSystemFont(ofSize: 16)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupPopup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
  
    }
    
    private func setupBackground() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        backgroundView.frame = view.bounds
        view.addSubview(backgroundView)
    }
    
    private func setupPopup() {
        popupView.backgroundColor = UIColor(red: 69/255, green: 20/255, blue: 59/255, alpha: 1.0)
        popupView.layer.cornerRadius = 20
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(popupView)
        popupView.addSubview(titleLabel)
        popupView.addSubview(messageLabel)
        
        // Stack view setup
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(deleteButton)
        
        // Add actions
        cancelButton.addTarget(self, action: #selector(CancelButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(DeleteButtonTapped), for: .touchUpInside)
        
        deleteButton.backgroundColor = UIColor(named: "Violet")
        
        // Auto Layout
        [titleLabel, messageLabel, cancelButton, deleteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonStackView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func CancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func DeleteButtonTapped() {
  
        VaultDataManager.shared.deleteMedia(at: Index.item)
        
        print(Index)

        
        self.dismiss(animated: true)
        
        NotificationCenter.default.post(name: .mediaUpdated, object: nil)
        // Add delete logic here
    }
}
