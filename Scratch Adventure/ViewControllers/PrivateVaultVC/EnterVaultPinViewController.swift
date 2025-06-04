//
//  EnterVaultPinViewController.swift
//  Scratch Adventure
//
//  Created by USER on 04/06/25.
//

import UIKit
import LocalAuthentication


class EnterVaultPinViewController: UIViewController {

    var customNavBarView: CustomNavigationBar?

    var setUpButtonBottomConstraint: NSLayoutConstraint?
    
    
    private let pinStackView = UIStackView()
    private var pinLabels: [UILabel] = []
    private var enteredPIN = "" {
        didSet {
            updatePINDisplay()
        }
    }

    var ContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var HeaderLabel: UILabel = {
        let Label = UILabel()
        Label.translatesAutoresizingMaskIntoConstraints = false
        Label.text = "Set up a PIN-code"
        Label.textColor = UIColor.white
        Label.font = UIFont.myBoldSystemFont(ofSize: 28)
        Label.textAlignment = .center
        Label.clipsToBounds = true
        return Label
    }()
    
    var DescriptionLabel: UILabel = {
        let Label = UILabel()
        Label.translatesAutoresizingMaskIntoConstraints = false
        Label.text = "Set up a PIN-code for your vault."
        Label.font = UIFont.mySystemFont(ofSize: 14)
        Label.textColor = UIColor.white
        Label.textAlignment = .center
        Label.clipsToBounds = true
        return Label
    }()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setupLabel()
        self.view.setUpBackground()
        self.view.addSubview(ContentContainer)
        setupPINBoxes()
        setupKeypad()
        
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enteredPIN = ""
    }
    
    private func setupPINBoxes() {
        pinStackView.axis = .horizontal
        pinStackView.alignment = .fill
        pinStackView.distribution = .equalSpacing
        pinStackView.spacing = 16
        ContentContainer.addSubview(pinStackView)
        pinStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pinStackView.topAnchor.constraint(equalTo: DescriptionLabel.bottomAnchor, constant: 30),
            pinStackView.centerXAnchor.constraint(equalTo: ContentContainer.centerXAnchor),
            pinStackView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        for _ in 0..<4 {
            let label = UILabel()
            label.layer.cornerRadius = 8
            label.clipsToBounds = true
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            label.backgroundColor = UIColor(hexString: "#9A03D0")?.withAlphaComponent(0.26) ?? UIColor.purple
            label.textColor = .white
            pinLabels.append(label)
            label.widthAnchor.constraint(equalToConstant: 50).isActive = true
            pinStackView.addArrangedSubview(label)
        }
    }

    private func updatePINDisplay() {
        for (index, label) in pinLabels.enumerated() {
            if index < enteredPIN.count {
                let charIndex = enteredPIN.index(enteredPIN.startIndex, offsetBy: index)
                label.text =  String(enteredPIN[charIndex])
            } else {
                label.text = ""
            }
        }
    }


    private func setupKeypad() {
        let keypad = UIView()
        ContentContainer.addSubview(keypad)
        keypad.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keypad.topAnchor.constraint(equalTo: pinStackView.bottomAnchor, constant: 50),
            keypad.centerXAnchor.constraint(equalTo: ContentContainer.centerXAnchor),
            keypad.widthAnchor.constraint(equalToConstant: 250),
            keypad.heightAnchor.constraint(equalToConstant: 330)
        ])
        
        let buttonData: [[(title: String?, imageName: String?)]] = [
            [("1", nil), ("2", nil), ("3", nil)],
            [("4", nil), ("5", nil), ("6", nil)],
            [("7", nil), ("8", nil), ("9", nil)],
            [(nil, "vault_previous"), ("0", nil), (nil, "Vault_faceLock")]
        ]

    
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        keypad.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: keypad.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: keypad.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: keypad.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: keypad.trailingAnchor)
        ])
        
        for row in buttonData {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 12
            hStack.distribution = .fillEqually
            
            for item in row {
                let button = UIButton(type: .system)
                if let title = item.title {
                    button.setTitle(title, for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
                    button.setTitleColor(.white, for: .normal)
                    button.tag = (item.title != nil) ? Int(item.title!) ?? -1 : -1
                } else if let imageName = item.imageName {
                    let image = UIImage(named: imageName)
                    button.setImage(image, for: .normal)
                    button.tintColor = .white // if using template rendering
                    button.imageView?.contentMode = .scaleAspectFit
                    
                    // Assign unique tag
                     if imageName == "vault_previous" {
                         button.tag = -99
                     } else if imageName == "Vault_faceLock" {
                         button.tag = -100
                     }
                }
                
               // button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
                button.layer.cornerRadius = 10
                button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
                hStack.addArrangedSubview(button)
            }
            
            stackView.addArrangedSubview(hStack)
        }
    }

    @objc private func keyTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0...9:
            if enteredPIN.count < 4 {
                enteredPIN.append("\(sender.tag)")
                if enteredPIN.count == 4 {
                    validatePIN()
                }
            }
        case -99:
            print("Revert tapped")
            // TODO: Toggle show/hide PIN
            
            if enteredPIN != "" {
                enteredPIN.removeLast()
            }
            
        case -100:
            print("Fake lock (Face ID) tapped")
            // TODO: Trigger biometric auth or dummy lock
            authenticateWithBiometrics()
        default:
            break
        }
    }
    
    
    private func validatePIN() {
        let correctPIN = VaultDataManager.shared.VaultPinGenerate

        if enteredPIN == correctPIN {
            print("✅ PIN matched")
            navigateToNextScreen()
        } else {
            print("❌ Incorrect PIN")
            shakePINBoxes()
            enteredPIN = ""
        }
    }
    
    private func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access secure area"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        print("✅ Face ID Success")
                        self.navigateToNextScreen()
                    } else {
                        print("❌ Authentication failed")
                        // Optionally show an alert
                    }
                }
            }
        } else {
            print("⚠️ Biometrics not available: \(error?.localizedDescription ?? "Unknown error")")
            // Optionally show alert that biometrics are unavailable
        }
    }


    private func navigateToNextScreen() {
        let VC = PrivateVaultViewController()
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true, completion: nil)
    }
    
    private func shakePINBoxes() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.4
        animation.values = [-10, 10, -8, 8, -5, 5, 0]
        pinStackView.layer.add(animation, forKey: "shake")
    }
    
    
    func setUpNavigationBar() {
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backIcon"),
            titleString: "",
        )
        
        guard let customNavBarView = customNavBarView else { return }
        
        customNavBarView.leftButtonTapped = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        customNavBarView.rightButtonTapped = { [weak self] in
            
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
    
    func setupLabel(){
        ContentContainer.addSubview(HeaderLabel)
        ContentContainer.addSubview(DescriptionLabel)
        NSLayoutConstraint.activate([
            HeaderLabel.topAnchor.constraint(equalTo: ContentContainer.topAnchor, constant: DeviceSize.isiPadDevice ? 200 : 50),
            HeaderLabel.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            HeaderLabel.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
            
            DescriptionLabel.topAnchor.constraint(equalTo: HeaderLabel.bottomAnchor, constant: 16),
            DescriptionLabel.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            DescriptionLabel.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
            
            
            
        ])
        
    }
}
