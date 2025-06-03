import UIKit

class LeaderboardsViewController: UIViewController {

    // Data for the leaderboard items
    let leaderboardItems = [
        (icon: "leaderboard_position", title: "Position Rate", subtitle: "Compare position count"),
        (icon: "leaderboard_strokes", title: "Sex Strokes", subtitle: "Compare by Sex Strokes"),
        (icon: "leaderboard_timing", title: "Timing", subtitle: "Compare by time you had sex")
    ]

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.register(LeaderboardItemCell.self, forCellReuseIdentifier: LeaderboardItemCell.identifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear // To see the bottom sheet background
        setupUI()
    }

    private func setupUI() {
        // Remove placeholder label if it exists
        view.subviews.forEach { $0.removeFromSuperview() }

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20), // Add some top padding
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension LeaderboardsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LeaderboardItemCell.identifier, for: indexPath) as? LeaderboardItemCell else {
            return UITableViewCell()
        }
        let item = leaderboardItems[indexPath.row]
        cell.configure(iconName: item.icon, title: item.title, subtitle: item.subtitle)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Adjust height as needed for cell content
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = leaderboardItems[indexPath.row]
        print("Tapped on: \(item.title)")
        // TODO: Navigate to the specific leaderboard screen
    }
}
