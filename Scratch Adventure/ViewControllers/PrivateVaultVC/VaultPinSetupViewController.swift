//
//  VaultPinSetupViewController.swift
//  Scratch Adventure
//
//  Created by USER on 23/05/25.
//

import UIKit
import DPOTPView

class VaultPinSetupViewController: UIViewController {

    var customNavBarView: CustomNavigationBar?

    var setUpButtonBottomConstraint: NSLayoutConstraint?

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
    
    var PinTextfield: DPOTPView = {
        let textField = DPOTPView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        return textField
    }()

    
    var setUpButton: UIButton = {
        let Button = UIButton()
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.setTitle("Set up", for: .normal)
        Button.setTitleColor(.white, for: .normal)
        Button.titleLabel?.font = UIFont.myBoldSystemFont(ofSize: 22)
        Button.layer.cornerRadius = 15
        Button.backgroundColor = UIColor(named: "Violet") ?? .systemPurple
        Button.clipsToBounds = true
        return Button
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setupButton()
        setupLabel()
        setupOtpView()
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        setUpButtonBottomConstraint?.constant = -keyboardHeight - 20 // add spacing above keyboard

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }

        setUpButtonBottomConstraint?.constant = -50

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
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
    
    func setupOtpView(){

        PinTextfield.count = 4
        PinTextfield.spacing = 10
        PinTextfield.fontTextField = UIFont.myBoldSystemFont(ofSize: 25)//UIFont(name: "HelveticaNeue-Bold", size: CGFloat(25.0))!
        PinTextfield.dismissOnLastEntry = false
        PinTextfield.borderColorTextField =  UIColor.white.withAlphaComponent(0.1)
        PinTextfield.selectedBorderColorTextField = .white
        PinTextfield.borderWidthTextField = 2
        PinTextfield.backGroundColorTextField = UIColor(hexString: "#9A03D0")?.withAlphaComponent(0.26) ?? UIColor.purple
        PinTextfield.tintColorTextField = .white
        PinTextfield.textColorTextField = .white
        PinTextfield.cornerRadiusTextField = 10
        
        }
    
    func setupLabel(){
        ContentContainer.addSubview(HeaderLabel)
        ContentContainer.addSubview(DescriptionLabel)
        ContentContainer.addSubview(PinTextfield)
        NSLayoutConstraint.activate([
            HeaderLabel.topAnchor.constraint(equalTo: ContentContainer.topAnchor, constant: 50),
            HeaderLabel.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            HeaderLabel.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
            
            DescriptionLabel.topAnchor.constraint(equalTo: HeaderLabel.bottomAnchor, constant: 16),
            DescriptionLabel.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            DescriptionLabel.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
            
            PinTextfield.topAnchor.constraint(equalTo: DescriptionLabel.bottomAnchor, constant: 30),
            PinTextfield.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            PinTextfield.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
            PinTextfield.heightAnchor.constraint(equalToConstant: 85)
            
            
            
        ])
        
    }
    
    func setupButton() {
        ContentContainer.addSubview(setUpButton)
        setUpButton.addTarget(self, action: #selector(SetupButtonTapped), for: .touchUpInside)
        setUpButtonBottomConstraint = setUpButton.bottomAnchor.constraint(equalTo: ContentContainer.bottomAnchor, constant: -50)
        NSLayoutConstraint.activate([
            setUpButtonBottomConstraint!,
            setUpButton.heightAnchor.constraint(equalToConstant: 50),
            setUpButton.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            setUpButton.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
        ])
    }
    
    
    @objc func SetupButtonTapped() {
        print(PinTextfield.text ?? "")
        
        let VC = PrivateVaultViewController()
        VC.modalPresentationStyle = .overFullScreen
        present(VC, animated: true, completion: nil)
        
    }
}


//extension VaultPinSetupViewController : OTPFieldViewDelegate {
//        func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
//            print("Has entered all OTP? \(hasEntered)")
//            return false
//        }
//        
//        func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
//            return true
//        }
//        
//        func enteredOTP(otp otpString: String) {
//            print("OTPString: \(otpString)")
//        }
//    }

//extension VaultPinSetupViewController: AEOTPTextFieldDelegate {
//    func didUserFinishEnter(the code: String) {
//        print(code)
//    }
//}


