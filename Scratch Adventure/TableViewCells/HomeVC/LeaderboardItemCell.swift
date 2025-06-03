import UIKit

class LeaderboardItemCell: UITableViewCell {
    static let identifier = "LeaderboardItemCell"

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.purple.withAlphaComponent(0.25) // Purple background
        view.layer.cornerRadius = 16
        return view
    }()

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white // Assuming icons are template images
        iv.backgroundColor = UIColor.black.withAlphaComponent(0.2) // Darker bg for icon
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.myBoldSystemFont(ofSize: 16)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.mySystemFont(ofSize: 13)
        return label
    }()

    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "rightArrowIcon")
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        

        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(arrowImageView)
    }

    private func setupLayout() {
        
        // Gradient Background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hexString: "AF0E78")?.withAlphaComponent(0.4).cgColor,  // Pinkish with 40% opacity
            UIColor(hexString: "9A03D0")?.withAlphaComponent(0.4).cgColor   // Purple with 40% opacity
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 20

        DispatchQueue.main.async {
            gradientLayer.frame = self.containerView.bounds
            self.containerView.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        NSLayoutConstraint.activate([
            // Container View constraints (with padding within the cell)
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DeviceSize.isiPadDevice ? 80 :20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DeviceSize.isiPadDevice ? -80 : -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Icon constraints
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 45),
            iconImageView.heightAnchor.constraint(equalToConstant: 45),

            // Arrow constraints
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 15),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),

            // Title constraints
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -2), // Slightly above center

            // Subtitle constraints
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 2), // Slightly below center
        ])
    }

    func configure(iconName: String, title: String, subtitle: String) {
        // Use placeholder image if specific icon isn't found
        iconImageView.image = UIImage(named: iconName) ?? UIImage(systemName: "chart.bar.xaxis")
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
} 
