import UIKit

final class LaunchVC: UIViewController {
    
    // MARK: - Properties
    var launchView: LaunchView { return self.view as! LaunchView }
    
//    var window: UIWindow?
    
//    init(window: UIWindow?) {
//        self.window = window
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationItem.backButtonTitle = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let tabBarController = TabBarController()
//            self.window?.rootViewController = tabBarController
            
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.pushViewController(tabBarController, animated: true)
        }
    }
    
    override func loadView() {
        self.view = LaunchView(frame: UIScreen.main.bounds)
    }
}
