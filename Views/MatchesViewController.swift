// MatchesViewController.swift

import UIKit

class MatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var matchedProfiles: [Profile] = []
    private let criteria: String
    private let tableView = UITableView()
    
    // Initialize with matched profiles and criteria
    init(profiles: [Profile], criteria: String) {
        self.matchedProfiles = profiles
        self.criteria = criteria
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Matches"
        
        setupTableView()
    }
    
    private func setupTableView() {
        // Register the cell type
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        
        // Set the delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the table view to the view hierarchy
        view.addSubview(tableView)
        
        // Layout constraints for the table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchedProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        
        // Configure the cell
        let profile = matchedProfiles[indexPath.row]
        cell.textLabel?.text = profile.name
        cell.detailTextLabel?.text = "\(profile.age) years, \(profile.location)"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the selected profile
        let selectedProfile = matchedProfiles[indexPath.row]
        
        // Navigate to MatchedProfileViewController
        let matchedProfileVC = MatchedProfileViewController(profile: selectedProfile)
        navigationController?.pushViewController(matchedProfileVC, animated: true)
    }
}
