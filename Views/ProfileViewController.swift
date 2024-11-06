import UIKit

class ProfileViewController: UIViewController {
    private let profile: Profile
    private let matchCriteria: String
    
    private let criteriaLabel = UILabel()
    private let profileContainerView = UIView()
    
    init(profile: Profile, criteria: String) {
        self.profile = profile
        self.matchCriteria = criteria
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.backgroundColor
        setupUI()
    }
    
    private func setupUI() {
        // Criteria Label setup
        criteriaLabel.text = "Matching Criteria: \(matchCriteria)"
        criteriaLabel.font = UIFont.boldSystemFont(ofSize: 18)
        criteriaLabel.textColor = UIConstants.textColor
        criteriaLabel.textAlignment = .center
        criteriaLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(criteriaLabel)
        
        // Profile Container setup
        profileContainerView.backgroundColor = UIConstants.secondaryColor
        profileContainerView.layer.cornerRadius = 15
        profileContainerView.layer.shadowColor = UIColor.black.cgColor
        profileContainerView.layer.shadowOpacity = 0.1
        profileContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        profileContainerView.layer.shadowRadius = 6
        profileContainerView.layer.borderWidth = 1
        profileContainerView.layer.borderColor = UIColor.lightGray.cgColor
        profileContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileContainerView)
        
        // Details Section setup
        let nameLabel = createDetailLabel(title: "Name", detail: profile.name)
        let ageLabel = createDetailLabel(title: "Age", detail: "\(profile.age)")
        let diagnosisLabel = createDetailLabel(title: "Primary Diagnosis", detail: profile.primaryDiagnosis)
        let hobbiesLabel = createDetailLabel(title: "Hobbies", detail: profile.hobbies.joined(separator: ", "))
        let locationLabel = createDetailLabel(title: "Location", detail: profile.location)
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, ageLabel, diagnosisLabel, hobbiesLabel, locationLabel])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        profileContainerView.addSubview(stackView)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            criteriaLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            criteriaLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            profileContainerView.topAnchor.constraint(equalTo: criteriaLabel.bottomAnchor, constant: 20),
            profileContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileContainerView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            
            stackView.topAnchor.constraint(equalTo: profileContainerView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor, constant: -20)
        ])
    }
    
    // Helper to create a styled detail section
    private func createDetailLabel(title: String, detail: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.systemBlue
        
        let detailLabel = UILabel()
        detailLabel.text = detail
        detailLabel.font = UIConstants.bodyFont
        detailLabel.textColor = .darkGray
        detailLabel.numberOfLines = 0
        
        let container = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        container.axis = .vertical
        container.spacing = 5
        return container
    }
}
