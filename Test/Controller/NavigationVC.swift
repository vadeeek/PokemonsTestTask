import UIKit

final class NavigationVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        tabBar.isHidden = true
    }
    
    private func setupTabBar() {
        let mainVC = createNavigationController(viewController: MainVC(), itemName: "Main", itemImage: "", boolLarge: true)
        
        viewControllers = [mainVC]
    }
    
    private func createNavigationController(viewController: UIViewController, itemName: String, itemImage: String, boolLarge: Bool) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(named: "\(itemImage)"), tag: 0)
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: -10)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = item
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.tintColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemPink
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        
        return navigationController
    }
}
