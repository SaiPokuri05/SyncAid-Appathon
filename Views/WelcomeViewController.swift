import UIKit

class WelcomeViewController: UIViewController, UserInfoViewControllerDelegate {
    
    private let logoImageView = UIImageView()
    private let createProfileButton = UIButton(type: .system)
    private let signInButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.backgroundColor
        setupUI()
    }
    
    private func setupUI() {
        // Configure logo image view
        logoImageView.image = UIImage(named: "SyncAidLogo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        // Configure create profile button
        createProfileButton.setTitle("Create Profile", for: .normal)
        createProfileButton.backgroundColor = UIConstants.secondaryColor
        createProfileButton.setTitleColor(UIConstants.buttonTextColor, for: .normal)
        createProfileButton.titleLabel?.font = UIConstants.bodyFont
        createProfileButton.layer.cornerRadius = 10
        createProfileButton.addTarget(self, action: #selector(createProfileTapped), for: .touchUpInside)
        createProfileButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createProfileButton)
        
        // Configure sign-in button
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.backgroundColor = UIConstants.secondaryColor
        signInButton.setTitleColor(UIConstants.buttonTextColor, for: .normal)
        signInButton.titleLabel?.font = UIConstants.bodyFont
        signInButton.layer.cornerRadius = 10
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Center logo image
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // Create Profile button constraints
            createProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createProfileButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            createProfileButton.widthAnchor.constraint(equalToConstant: 200),
            createProfileButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Sign-In button constraints
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: createProfileButton.bottomAnchor, constant: 20),
            signInButton.widthAnchor.constraint(equalToConstant: 200),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func createProfileTapped() {
        let userInfoVC = UserInfoViewController()
        userInfoVC.delegate = self
        navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    @objc private func signInTapped() {
        // Navigate to HomeViewController to display suggestions
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true, completion: nil)
    }
    
    // MARK: - UserInfoViewControllerDelegate
    
    func didCompleteProfileSetup(user: User) {
        UserManager.shared.user = user
        let mainTabBarController = MainTabBarController()
        mainTabBarController.modalPresentationStyle = .fullScreen
        present(mainTabBarController, animated: true, completion: nil)
    }
}
