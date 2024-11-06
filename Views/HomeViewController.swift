import UIKit

class HomeViewController: UIViewController {
    
    private let greetingLabel = UILabel()
    private let collectionView: UICollectionView
    private var suggestions: [String] = []
    private let client = OpenAIClient()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 15
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 100)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.backgroundColor
        setupUI()
        fetchSuggestions()  // Fetch suggestions when view loads
    }

    private func setupUI() {
        // Greeting label setup
        greetingLabel.text = "Welcome, \(UserManager.shared.user?.name ?? "User")!"
        greetingLabel.font = UIConstants.titleFont
        greetingLabel.textColor = UIConstants.textColor
        greetingLabel.textAlignment = .center
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(greetingLabel)
        
        // Collection view configuration
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(SuggestionCell.self, forCellWithReuseIdentifier: "SuggestionCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func fetchSuggestions() {
        guard let primaryDiagnosis = UserManager.shared.user?.primaryDiagnosis else { return }
        
        client.fetchSuggestions(for: primaryDiagnosis) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let suggestions):
                    // Display the fetched suggestions
                    self?.suggestions = suggestions
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Error fetching suggestions: \(error)")
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionCell", for: indexPath) as! SuggestionCell
        cell.configure(with: suggestions[indexPath.row])
        return cell
    }
}
