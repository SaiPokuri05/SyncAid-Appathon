import UIKit

class ProfileTabViewController: UIViewController {
    
    private let profileHeaderView = UIView()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 45
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let locationLabel = UILabel()
    private let primaryDiagnosisLabel = UILabel()
    private let hobbiesLabel = UILabel()
    
    private let detailsStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.backgroundColor
        title = "Profile"
        
        setupProfileHeaderView()
        setupProfileDetails()
        displayUserProfile()
    }
    
    private func setupProfileHeaderView() {
        // Setting up the header with profile image and name
        profileHeaderView.backgroundColor = UIConstants.backgroundColor
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileHeaderView)
        
        profileHeaderView.addSubview(profileImageView)
        profileHeaderView.addSubview(nameLabel)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileHeaderView.heightAnchor.constraint(equalToConstant: 150),
            
            profileImageView.centerXAnchor.constraint(equalTo: profileHeaderView.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: profileHeaderView.centerYAnchor, constant: -10),
            profileImageView.widthAnchor.constraint(equalToConstant: 90),
            profileImageView.heightAnchor.constraint(equalToConstant: 90),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: profileHeaderView.centerXAnchor)
        ])
    }
    
    private func setupProfileDetails() {
        // Stack view for organizing detail fields
        detailsStackView.axis = .vertical
        detailsStackView.spacing = 15
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailsStackView)
        
        detailsStackView.addArrangedSubview(createInfoRow(title: "Age", valueLabel: ageLabel))
        detailsStackView.addArrangedSubview(createInfoRow(title: "Location", valueLabel: locationLabel))
        detailsStackView.addArrangedSubview(createInfoRow(title: "Primary Diagnosis", valueLabel: primaryDiagnosisLabel))
        detailsStackView.addArrangedSubview(createInfoRow(title: "Hobbies", valueLabel: hobbiesLabel))
        
        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: 20),
            detailsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func createInfoRow(title: String, valueLabel: UILabel) -> UIView {
        // Title label for each field
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .darkGray
        
        // Value label for each field
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.textColor = .black
        valueLabel.numberOfLines = 0
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack view to hold title and value labels
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        
        // Container view for white box styling
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        
        return containerView
    }
    
    private func displayUserProfile() {
        guard let user = UserManager.shared.user else { return }
        
        nameLabel.text = user.name
        ageLabel.text = "\(user.age)"
        locationLabel.text = user.location
        primaryDiagnosisLabel.text = user.primaryDiagnosis
        hobbiesLabel.text = user.hobbies.joined(separator: ", ")
    }
}
