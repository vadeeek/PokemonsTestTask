import UIKit

enum Tabs: Int {
    case pokemons
    case items
    case compare
    case profile
}

final class TabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        setUpTabs()
    //        setUpAppearance()
    //        configure()
    //    }
    
    //    private func setUpTabs() {
    ////        let launchVC = LaunchVC()
    //        let mainVC = MainVC()
    //        let itemsVC = ItemsVC()
    //        let favoritesVC = FavoritesVC()
    ////        let settingsVC = RMSettingsViewController()
    //
    ////        let nav1 = UINavigationController(rootViewController: launchVC)
    //        let nav2 = UINavigationController(rootViewController: mainVC)
    //        let nav3 = UINavigationController(rootViewController: itemsVC)
    //        let nav4 = UINavigationController(rootViewController: favoritesVC)
    ////        let nav4 = UINavigationController(rootViewController: settingsVC)
    //
    //        nav2.tabBarItem = UITabBarItem(title: "Pokemons",
    //                                       image: UIImage(systemName: "person"),
    //                                       tag: 1)
    //        nav3.tabBarItem = UITabBarItem(title: "Items",
    //                                       image: UIImage(systemName: "globe"),
    //                                       tag: 2)
    //        nav4.tabBarItem = UITabBarItem(title: "Favorites",
    //                                       image: UIImage(systemName: "star"),
    //                                       tag: 3)
    ////        nav5.tabBarItem = UITabBarItem(title: "Settings",
    ////                                       image: UIImage(systemName: "gear"),
    ////                                       tag: 4)
    //
    ////        for nav in [nav1, nav2, nav3/*, nav4*/] {
    ////            nav.navigationBar.prefersLargeTitles = true
    ////        }
    //
    //        setViewControllers([
    //            nav2,
    //            nav3,
    //            nav4/*, nav4*/
    //        ], animated: true)
    //    }
    
    private func configure() {
        tabBar.tintColor = Resources.Colors.active
        tabBar.barTintColor = .black
        tabBar.backgroundColor = .black
        
        let pokemonsController = PokemonsVC()
        let itemsController = ItemsVC()
        let compareController = CompareVC()
        let profileController = ProfileVC()
        
        let pokemonsNavigation = UINavigationController(rootViewController: pokemonsController)
        let itemsNavigation = UINavigationController(rootViewController: itemsController)
        let compareNavigation = UINavigationController(rootViewController: compareController)
        let profileNavigation = UINavigationController(rootViewController: profileController)
        
        pokemonsController.tabBarItem = UITabBarItem(title: Resources.Strings.TabBar.pokemons,
                                                     image: Resources.Images.TabBar.pokemons_unselected,
                                                     selectedImage: Resources.Images.TabBar.pokemons_selected)
        pokemonsController.tabBarItem.tag = Tabs.pokemons.rawValue
        itemsController.tabBarItem = UITabBarItem(title: Resources.Strings.TabBar.items,
                                                  image: Resources.Images.TabBar.items_unselected,
                                                  selectedImage: Resources.Images.TabBar.items_selected)
        itemsController.tabBarItem.tag = Tabs.items.rawValue
        compareController.tabBarItem = UITabBarItem(title: Resources.Strings.TabBar.compare,
                                                    image: Resources.Images.TabBar.compare_unselected,
                                                    selectedImage: Resources.Images.TabBar.compare_selected)
        compareController.tabBarItem.tag = Tabs.compare.rawValue
        profileController.tabBarItem = UITabBarItem(title: Resources.Strings.TabBar.profile,
                                                      image: Resources.Images.TabBar.profile_unselected,
                                                      selectedImage: Resources.Images.TabBar.profile_selected)
        profileController.tabBarItem.tag = Tabs.profile.rawValue
        
        setViewControllers([
            pokemonsNavigation,
            itemsNavigation,
            compareNavigation,
            profileNavigation
        ], animated: false)
    }
    //    private func setUpAppearance() {
    //        let appearance = UITabBarAppearance()
    //        appearance.backgroundColor = .black
    //        appearance.shadowColor = nil
    //        self.tabBar.standardAppearance = appearance
    //
    //        if #available(iOS 15.0, *) {
    //            self.tabBar.scrollEdgeAppearance = appearance
    //        }
    //        UITabBar.appearance().tintColor = .systemOrange
    ////        self.tabBar.isTranslucent = true
    //    }
}
