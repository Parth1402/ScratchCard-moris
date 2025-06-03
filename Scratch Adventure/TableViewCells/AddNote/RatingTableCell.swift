import UIKit

class RatingTableCell: UITableViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "RatingTableCell"

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.mySystemFont(ofSize: 16)
        label.textColor = .white // Or your desired color
        label.layer.cornerRadius = 8
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()

    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually // Adjust as needed
        return stackView
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.backgroundColor = .clear // Match your background
        backgroundColor = .clear

        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingStackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 120), // Adjust width as needed
            titleLabel.heightAnchor.constraint(equalToConstant: 30), // Adjust height as needed

            ratingStackView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            ratingStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingStackView.heightAnchor.constraint(equalToConstant: 40) // Adjust height as needed
        ])
    }

    // MARK: - Configuration

    func configure(title: String, ratingType: RatingType) {
        
        if title == "Foreplay" {
            titleLabel.backgroundColor = UIColor(hexString: "#0C9A89")
        }else if title == "Sex" {
            titleLabel.backgroundColor = UIColor(hexString: "#B037DA")
        }else if title == "Riskiness" {
            titleLabel.backgroundColor = UIColor(hexString: "#E53694")
        }else if title == "Privacy" {
            titleLabel.backgroundColor = UIColor(hexString: "#268FF0")
        }else if title == "Enjoyment" {
            titleLabel.backgroundColor = UIColor(hexString: "#9A20F9")
        }else if title == "Orgasms" {
            titleLabel.backgroundColor = UIColor(hexString: "#3C31BE")
        }
        
        titleLabel.text = title
        // TODO: Configure ratingStackView based on ratingType
        configureRatingView(for: ratingType)
    }

    private func configureRatingView(for type: RatingType) {
        // Clear existing views
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        switch type {
        case .stars(let count):
            setupStarRatingView(count: count)
        case .emojis(let emojis):
            setupEmojiRatingView(emojis: emojis)
        case .stepper(let initialValue):
            setupStepperView(initialValue: initialValue)
        }
    }

    // MARK: - Rating View Setups (Placeholder)

    private func setupStarRatingView(count: Int) {
        // TODO: Implement star rating view
        for i in 0..<5 {
            let button = UIButton()
            button.setImage(UIImage(named: i < count ? "StarFill" : "StarEmpty"), for: .normal)
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            button.tag = i // Use tag to identify the star index
            button.widthAnchor.constraint(equalToConstant: 40).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            ratingStackView.addArrangedSubview(button)
        }
    }

    private func setupEmojiRatingView(emojis: [UIImage]) {
        // TODO: Implement emoji rating view
        for (index, emoji) in emojis.enumerated() {
             let button = UIButton()
             button.setImage(emoji, for: .normal)
             button.titleLabel?.font = UIFont.mymediumSystemFont(ofSize: 24) // Adjust size
             button.addTarget(self, action: #selector(emojiTapped(_:)), for: .touchUpInside)
             button.tag = index // Use tag to identify the emoji index
            button.widthAnchor.constraint(equalToConstant: 40).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
             ratingStackView.addArrangedSubview(button)
         }
         // Add initial selection state if needed
    }

    private func setupStepperView(initialValue: Int) {
        // Create minus button
        let minusButton = UIButton(type: .system)
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.white, for: .normal)
        minusButton.titleLabel?.font = UIFont.mySystemFont(ofSize: 24)
        minusButton.layer.cornerRadius = 20
        minusButton.layer.borderWidth = 1
        minusButton.layer.borderColor = UIColor.white.cgColor
        minusButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        minusButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        minusButton.addTarget(self, action: #selector(stepperChanged(_:)), for: .touchUpInside)
        minusButton.tag = -1 // So you can know it's minus

        // Create value label
        let valueLabel = UILabel()
        valueLabel.text = "\(initialValue)"
        valueLabel.textAlignment = .center
        valueLabel.textColor = .white
        valueLabel.font = UIFont.mymediumSystemFont(ofSize: 20)
        valueLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true

        // Create plus button
        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.white, for: .normal)
        plusButton.titleLabel?.font = UIFont.mySystemFont(ofSize: 24)
        plusButton.layer.cornerRadius = 20
        plusButton.layer.borderWidth = 1
        plusButton.layer.borderColor = UIColor.white.cgColor
        plusButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        plusButton.addTarget(self, action: #selector(stepperChanged(_:)), for: .touchUpInside)
        plusButton.tag = 1 // So you can know it's plus

        // Configure the stack view
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // Clear previous
        ratingStackView.axis = .horizontal
        ratingStackView.alignment = .center
        ratingStackView.spacing = 8
        ratingStackView.distribution = .equalCentering

        // Add to stack view
        ratingStackView.addArrangedSubview(minusButton)
        ratingStackView.addArrangedSubview(valueLabel)
        ratingStackView.addArrangedSubview(plusButton)
        
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            ratingStackView.heightAnchor.constraint(equalToConstant: 50), // Adjust height as needed
            ratingStackView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            ratingStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])

        // Save the label if you need to update value later
     //   self.valueLabel = valueLabel
    }


    // MARK: - Actions (Placeholder)

    @objc private func starTapped(_ sender: UIButton) {
        let selectedRating = sender.tag + 1
        print("Star rating: \(selectedRating)")
        // TODO: Update UI and notify delegate/view model
        // Example: Update stars visually
        for (index, view) in ratingStackView.arrangedSubviews.enumerated() {
            if let button = view as? UIButton {
                button.setImage(UIImage(named: index < selectedRating ? "StarFill" : "StarEmpty"), for: .normal)
            }
        }
    }

    @objc private func emojiTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        print("Emoji selected: \(selectedIndex)") // Or get the emoji string
        // TODO: Update UI (e.g., highlight selected emoji) and notify delegate/view model
    }

    @objc private func stepperChanged(_ sender: UIButton) {
        // TODO: Update value label and notify delegate/view model
        guard let valueLabel = ratingStackView.arrangedSubviews[1] as? UILabel,
              var currentValue = Int(valueLabel.text ?? "0") else { return }

        if sender.title(for: .normal) == "+" {
            currentValue += 1
        } else if sender.title(for: .normal) == "-" {
            currentValue = max(0, currentValue - 1) // Prevent negative values if needed
        }
        valueLabel.text = "\(currentValue)"
        print("Stepper value: \(currentValue)")
    }

    // MARK: - Rating Type Enum

    enum RatingType {
        case stars(value: Int) // Renamed from currentRating
        case emojis(images: [UIImage]) // Renamed from list and clarified type
        case stepper(value: Int) // Renamed from currentValue
    }
} 
