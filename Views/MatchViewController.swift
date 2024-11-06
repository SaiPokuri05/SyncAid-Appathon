import UIKit

class MatchViewController: UIViewController {
    private let criteriaOptions = ["Age", "Hobbies", "Primary Diagnosis", "Location"]
    private var selectedCriteria: String?
    private let user: User
    private var sampleProfiles: [Profile] = []
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let matchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Find Match", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
        sampleProfiles = [
            Profile(name: "Joseph Johnson", age: 48, primaryDiagnosis: "Colorectal Cancer", hobbies: ["Cooking", "Reading", "Board Games"], location: "Columbus, OH"),
            Profile(name: "Manuel Sanchez", age: 52, primaryDiagnosis: "Colorectal Cancer", hobbies: ["Baking", "Knitting", "Reading"], location: "Columbus, OH"),
            Profile(name: "Demetrius Jones", age: 50, primaryDiagnosis: "Type 2 Diabetes", hobbies: ["Cooking", "Painting", "Reading"], location: "Columbus, OH"),
            Profile(name: "Diego Lopez", age: 35, primaryDiagnosis: "Type 2 Diabetes", hobbies: ["Biking", "Outdoor Running", "Swimming"], location: "Miami, FL"),
            Profile(name: "Elizabeth Rowe", age: 29, primaryDiagnosis: "Traumatic Brain Injury", hobbies: ["Walking", "Birdwatching", "Photography"], location: "Columbus, OH")
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.primaryColor
        setupScrollView()
        setupUI()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Ready to Match?"
        titleLabel.font = UIConstants.titleFont
        titleLabel.textColor = UIConstants.textColor
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let instructionLabel = UILabel()
        instructionLabel.text = "Select a criterion to find a match:"
        instructionLabel.font = UIConstants.subtitleFont
        instructionLabel.textColor = UIConstants.textColor
        instructionLabel.textAlignment = .center
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let criteriaStackView = createCriteriaButtons()
        
        matchButton.addTarget(self, action: #selector(findMatches), for: .touchUpInside)
        
        [titleLabel, instructionLabel, criteriaStackView, matchButton].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            instructionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            criteriaStackView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 30),
            criteriaStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            criteriaStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            matchButton.topAnchor.constraint(equalTo: criteriaStackView.bottomAnchor, constant: 40),
            matchButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            matchButton.widthAnchor.constraint(equalToConstant: 200),
            matchButton.heightAnchor.constraint(equalToConstant: 50),
            matchButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func createCriteriaButtons() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for option in criteriaOptions {
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
            button.addTarget(self, action: #selector(criteriaButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }
    
    @objc private func criteriaButtonTapped(_ sender: UIButton) {
        selectedCriteria = sender.currentTitle
        for case let button as UIButton in sender.superview?.subviews ?? [] {
            button.backgroundColor = .white
        }
        sender.backgroundColor = .gray
    }
    
    @objc private func findMatches() {
        guard let criteria = selectedCriteria else {
            let alert = UIAlertController(title: "No Criteria Selected", message: "Please select a matching criterion.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let matchedProfiles = findMatchingProfiles(for: criteria)
        let matchesVC = MatchesViewController(profiles: matchedProfiles, criteria: criteria)
        navigationController?.pushViewController(matchesVC, animated: true)
    }
    
    private func findMatchingProfiles(for criteria: String) -> [Profile] {
        switch criteria {
        case "Age":
            return sampleProfiles.filter { $0.age == Int(user.age) }
        case "Hobbies":
            let userHobbies = Set(user.hobbies)
            return sampleProfiles.filter { !userHobbies.isDisjoint(with: Set($0.hobbies)) }
        case "Primary Diagnosis":
            return sampleProfiles.filter { $0.primaryDiagnosis == user.primaryDiagnosis }
        case "Location":
            return sampleProfiles.filter { $0.location == user.location }
        default:
            return []
        }
    }
}
