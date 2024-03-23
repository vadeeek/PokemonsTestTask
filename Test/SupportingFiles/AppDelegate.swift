import UIKit
import FirebaseCore
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let launchVC = LaunchVC()
        let navigationController = UINavigationController(rootViewController: launchVC)
        print("1. \(UserDefaults.standard.bool(forKey: "isRememberMe"))")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .dark
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if !UserDefaults.standard.bool(forKey: "isRememberMe") {
            print("2. \(UserDefaults.standard.bool(forKey: "isRememberMe"))")
            if Auth.auth().currentUser != nil {
                do {
                    try Auth.auth().signOut()
                } catch let error as NSError {
                    print("Ошибка при выходе из аккаунта: \(error.localizedDescription)")
                }
            }
        }
    }
}
