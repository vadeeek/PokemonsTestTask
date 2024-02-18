import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
        setUpAppearance()
    }

    private func setUpTabs() {
//        let launchVC = LaunchVC()
        let mainVC = MainVC()
        let itemsVC = ItemsVC()
        let favoritesVC = FavoritesVC()
//        let settingsVC = RMSettingsViewController()

//        let nav1 = UINavigationController(rootViewController: launchVC)
        let nav2 = UINavigationController(rootViewController: mainVC)
        let nav3 = UINavigationController(rootViewController: itemsVC)
        let nav4 = UINavigationController(rootViewController: favoritesVC)
//        let nav4 = UINavigationController(rootViewController: settingsVC)

        nav2.tabBarItem = UITabBarItem(title: "Pokemons",
                                       image: UIImage(systemName: "person"),
                                       tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Items",
                                       image: UIImage(systemName: "globe"),
                                       tag: 2)
        nav4.tabBarItem = UITabBarItem(title: "Favorites",
                                       image: UIImage(systemName: "star"),
                                       tag: 3)
//        nav5.tabBarItem = UITabBarItem(title: "Settings",
//                                       image: UIImage(systemName: "gear"),
//                                       tag: 4)

//        for nav in [nav1, nav2, nav3/*, nav4*/] {
//            nav.navigationBar.prefersLargeTitles = true
//        }

        setViewControllers(
            [nav2, nav3, nav4/*, nav4*/],
            animated: true
        )
    }
    
    private func setUpAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .black
        appearance.shadowColor = nil
        self.tabBar.standardAppearance = appearance
            
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = appearance
        }
        UITabBar.appearance().tintColor = .systemOrange
//        self.tabBar.isTranslucent = true
    }
}

