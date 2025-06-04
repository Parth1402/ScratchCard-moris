//
//  AudioRecorderPopupViewController.swift
//  Scratch Adventure
//
//  Created by USER on 30/05/25.
//


import UIKit

import UIKit

class AudioRecorderPopupViewController: UIViewController {

    // Dimmed background
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // White popup card
    private let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Close (X) button
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_recordAlert_close"), for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Microphone icon
    private let micImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_recordAlert_mic") ?? UIImage(systemName: "mic.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // Title label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Audio recorder"
        label.font = UIFont.myBoldSystemFont(ofSize: 22)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Description label
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "We will use your microphone to collect and track you sex life. This data is absolutely private and it will not be used in any way other than for tracking and providing more specific data for your statistics like average sex time, bumps count and else."
        label.font = UIFont.mySystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Turn On button
    private let turnOnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Turn On", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "Violet") ?? .systemPurple
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.myBoldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        closeButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
    }

    private func setupUI() {
        view.addSubview(dimmedView)
        view.addSubview(popupView)

        popupView.addSubview(closeButton)
        popupView.addSubview(micImageView)
        popupView.addSubview(titleLabel)
        popupView.addSubview(descriptionLabel)
        popupView.addSubview(turnOnButton)

        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),

            micImageView.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 40),
            micImageView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            micImageView.heightAnchor.constraint(equalToConstant: 120),
            micImageView.widthAnchor.constraint(equalToConstant: 120),

            titleLabel.topAnchor.constraint(equalTo: micImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant:  20),
            titleLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant:  -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: DeviceSize.isiPadDevice ? 120 : 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: DeviceSize.isiPadDevice ? -120 : -20),

            turnOnButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            turnOnButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: DeviceSize.isiPadDevice ? 80 : 20),
            turnOnButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: DeviceSize.isiPadDevice ? -80 : -20),
            turnOnButton.heightAnchor.constraint(equalToConstant: 50),
            turnOnButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: DeviceSize.isiPadDevice ? -50 : -24)
        ])
    }

    @objc private func dismissPopup() {
        dismiss(animated: true, completion: nil)
    }
}
