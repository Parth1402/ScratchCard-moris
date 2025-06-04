//
//  DeletevaultImagePopupViewController.swift
//  Scratch Adventure
//
//  Created by USER on 30/05/25.
//


import UIKit

class RecordAudioAlertViewController: UIViewController {
    
    private let backgroundView = UIView()
    private let popupView = UIView()
    
     var Index = IndexPath()
    
    var isvideo = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Record audio?"
        label.font = UIFont.myBoldSystemFont(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "You can record audio of your sex, we wont record without your permission, but you still will get the analytics of our AI recognizer"
        label.font = UIFont.mySystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let NoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("No", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.myBoldSystemFont(ofSize: 16)
        return button
    }()
    
    private let RecordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Record", for: .normal)
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
        
        titleLabel.text = isvideo ? "Record video?" : "Record audio?"
        messageLabel.text = isvideo ? "You can record video of your sex. You will find the record in your private vault and can be sure that it is completely safe." : "You can record audio of your sex, we wont record without your permission, but you still will get the analytics of our AI recognizer"
        popupView.backgroundColor = UIColor(red: 69/255, green: 20/255, blue: 59/255, alpha: 1.0)
        popupView.layer.cornerRadius = 20
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(popupView)
        popupView.addSubview(titleLabel)
        popupView.addSubview(messageLabel)
        
        // Stack view setup
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(NoButton)
        buttonStackView.addArrangedSubview(RecordButton)
        
        // Add actions
        NoButton.addTarget(self, action: #selector(NoButtonTapped), for: .touchUpInside)
        RecordButton.addTarget(self, action: #selector(RecordButtonTapped), for: .touchUpInside)
        
        RecordButton.backgroundColor = UIColor(named: "Violet")
        
        // Auto Layout
        [titleLabel, messageLabel, NoButton, RecordButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  DeviceSize.isiPadDevice ? 100 : 20),
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: DeviceSize.isiPadDevice ? -100 : -20),
            
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
    
    @objc func NoButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func RecordButtonTapped() {
        
        if isvideo {
            self.dismiss(animated: true)
            
            NotificationCenter.default.post(name: .VideoAlert, object: nil)
        }else {
            self.dismiss(animated: true)
            
            NotificationCenter.default.post(name: .AudioAlert, object: nil)
        }
  
       
        // Add delete logic here
    }
}
