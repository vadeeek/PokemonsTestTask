import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let navigationController = setupNavigationController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .dark
        return true
    }
    
    func setupNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: MainVC())
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
