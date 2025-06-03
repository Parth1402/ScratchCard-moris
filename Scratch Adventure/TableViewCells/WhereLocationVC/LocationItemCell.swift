//
//  LocationItemCell.swift
//  Scratch Adventure
//
//  Created by USER on 22/05/25.
//

import UIKit

class LocationItemCell: UITableViewCell {
    
    static let identifier = "LocationItemCell"
    
    private var selectedSubItemIndices: [IndexPath] = []
    private var locationArray = [LocationItem]()
    
    var isSelectLocationClick: ((IndexPath, [IndexPath]) -> Void)?
    
    var checkedCount = 0
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let subLabel = UILabel()
    
    private let gradientLayer = CAGradientLayer()
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.5)
        return view
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 40
        return tv
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.image = UIImage(named: "ic_addLocation_BG")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
             backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
             backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
             backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
      //  setupGradientBackground()
        
        // Labels
        titleLabel.font = UIFont.myBoldSystemFont(ofSize: 17)
        titleLabel.textColor = .white
        
        subtitleLabel.font = UIFont.mySystemFont(ofSize: 14)
        subtitleLabel.textColor = .white.withAlphaComponent(0.8)
        subtitleLabel.numberOfLines = 0
        
        subLabel.font = UIFont.mySystemFont(ofSize: 12)
        subLabel.textColor = .white.withAlphaComponent(0.7)
        subLabel.numberOfLines = 0
        subLabel.textAlignment = .right
        
        let horizontalStack = UIStackView(arrangedSubviews: [titleLabel, subLabel])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 4
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [horizontalStack, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(stack)
        containerView.addSubview(lineView)
        containerView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            lineView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 8),
            lineView.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            tableView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 100)
        tableViewHeightConstraint.isActive = true
        tableView.isScrollEnabled = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationItemSubCell.self, forCellReuseIdentifier: LocationItemSubCell.identifier)
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func configure(data: LocationSection) {
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        locationArray = data.items
        subLabel.text = data.Counttitle
        selectedSubItemIndices.removeAll()
        tableView.reloadData()
    }
    
    private func setupGradientBackground() {
        gradientLayer.colors = [
            UIColor(hexString: "AF0E78")?.withAlphaComponent(0.4).cgColor ?? UIColor.clear.cgColor,
            UIColor(hexString: "9A03D0")?.withAlphaComponent(0.4).cgColor ?? UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 16
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            let height = tableView.contentSize.height
            if tableViewHeightConstraint.constant != height {
                tableViewHeightConstraint.constant = height
                setNeedsLayout()
                layoutIfNeeded()
            }
        }
    }
}

extension LocationItemCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationItemSubCell.identifier, for: indexPath) as? LocationItemSubCell else {
            return UITableViewCell()
        }
        
        let item = locationArray[indexPath.row]
        let isSelected = selectedSubItemIndices.contains(indexPath)
        cell.configure(with: item)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = selectedSubItemIndices.firstIndex(of: indexPath) {
            // Deselect item
            selectedSubItemIndices.remove(at: index)
        } else {
            // Select item
            selectedSubItemIndices.append(indexPath)
        }
        
        checkedCount = locationArray.filter { $0.isSelected }.count
        
        isSelectLocationClick?(indexPath, selectedSubItemIndices)
        
        tableView.reloadRows(at: [indexPath], with: .automatic) // Refresh to update UI
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
