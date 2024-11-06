import UIKit

class MainTabBarController: UITabBarController {
    
    private let chatVC = ChatViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.circle"), tag: 0)
        
        let profileTabVC = ProfileTabViewController()
        profileTabVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        
        let matchVC = MatchViewController(user: UserManager.shared.user!)
        matchVC.tabBarItem = UITabBarItem(title: "Matching", image: UIImage(systemName: "heart.circle"), tag: 2)
        
        chatVC.tabBarItem = UITabBarItem(title: "Chatting", image: UIImage(systemName: "message.circle"), tag: 3)
        
        let activitiesVC = ActivitiesViewController()
        activitiesVC.tabBarItem = UITabBarItem(title: "Activities", image: UIImage(systemName: "play.circle"), tag: 4)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let profileNav = UINavigationController(rootViewController: profileTabVC)
        let matchNav = UINavigationController(rootViewController: matchVC)
        let chatNav = UINavigationController(rootViewController: chatVC)
        let activitiesNav = UINavigationController(rootViewController: activitiesVC)
        
        viewControllers = [homeNav, profileNav, matchNav, chatNav, activitiesNav]
        
        tabBar.tintColor = UIColor.systemBlue
        tabBar.backgroundColor = UIColor.systemGray6
    }
    
    // Method to switch to the chat tab with a matched profile
    func switchToChatTab(with profile: Profile) {
        selectedIndex = 3 // Switch to the chat tab
        chatVC.initiateChat(with: profile)
    }
}
