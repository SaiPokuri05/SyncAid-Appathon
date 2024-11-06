import UIKit

class ActivitiesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let collectionView: UICollectionView
    private var recommendations: [Activity] = []
    private let client = OpenAIClient()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 200) // Fixed height for better visibility

        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.backgroundColor
        title = "Activities"
        
        setupCollectionView()
        fetchRecommendations()
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ActivityCardCell.self, forCellWithReuseIdentifier: "ActivityCardCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchRecommendations() {
        guard let hobbies = UserManager.shared.user?.hobbies, !hobbies.isEmpty else {
            print("No hobbies found in UserManager.")
            return
        }
        
        guard let location = UserManager.shared.user?.location else {
            print("No location found in UserManager.")
            return
        }
        
        client.fetchActivityRecommendations(for: hobbies, location: location) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let activities):
                    self?.recommendations = activities
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Error fetching recommendations: \(error)")
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCardCell", for: indexPath) as! ActivityCardCell
        cell.configure(with: recommendations[indexPath.row])
        return cell
    }
}
