import UIKit

class NotesViewController: UIViewController {

    let notesData = [
        ("In front of a mirror", "Protection used", "Wed, 12 Feb 2025", "Los Angeles, CA", 5.0, 2, ["Oral", "Anal", "Bottoming","Oral", "Anal", "Bottoming", "+2"]),
        ("Another entry", "No protection", "Thu, 13 Feb 2025", "San Francisco, CA", 4.0, 1, ["Kissing", "+1"]),
        ("Third time", "Protection used", "Fri, 14 Feb 2025", "New York, NY", 4.5, 3, ["Oral", "Top", "+3"])
    ]

    lazy var addNoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        // Title & Image
        button.setTitle(" Add Diary Note", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal) // SF Symbol
        button.tintColor = .white

        // Font
        button.titleLabel?.font = UIFont.mymediumSystemFont(ofSize: 16)

        // Content Padding
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 24, bottom: 14, right: 24)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true

        // Gradient Background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hexString: "AF0E78")?.withAlphaComponent(0.4).cgColor,  // Pinkish with 40% opacity
            UIColor(hexString: "9A03D0")?.withAlphaComponent(0.4).cgColor   // Purple with 40% opacity
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 16

        DispatchQueue.main.async {
            gradientLayer.frame = button.bounds
            button.layer.insertSublayer(gradientLayer, at: 0)
        }

        // Keep gradient updated on layout change
        button.layoutIfNeeded()
        button.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)

        return button
    }()



    lazy var notesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear // dark background for contrast
        setupUI()
    }

    private func setupUI() {
        view.addSubview(addNoteButton)
        view.addSubview(notesTableView)
        
        if DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                addNoteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                addNoteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
                addNoteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
                addNoteButton.heightAnchor.constraint(equalToConstant: 50),

                notesTableView.topAnchor.constraint(equalTo: addNoteButton.bottomAnchor, constant: DeviceSize.isiPadDevice ? 16 : 8),
                notesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                notesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                notesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }else {
            NSLayoutConstraint.activate([
                addNoteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                addNoteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                addNoteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                addNoteButton.heightAnchor.constraint(equalToConstant: 50),

                notesTableView.topAnchor.constraint(equalTo: addNoteButton.bottomAnchor, constant: 8),
                notesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                notesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                notesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }

  
    }

    @objc private func addNoteTapped() {
        print("Add Diary Note tapped")
        
        let VC = AddDiaryNoteViewController()
        VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: false)
    }
}

extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else {
            return UITableViewCell()
        }
        let note = notesData[indexPath.row]
        cell.configure(title: note.0, subtitle: note.1, date: note.2, location: note.3, rating: note.4, orgasms: note.5, tags: note.6, isHome: true)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Add Diary Filled Note tapped")
        
        let VC = AddDiaryNoteFilledViewController()
        VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: false)
    }
}
