import UIKit

final class LaunchVC: UIViewController {
    
    // MARK: - Properties
    var launchView: LaunchView { return self.view as! LaunchView }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationItem.backButtonTitle = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let tabBarController = TabBarController()
            self.navigationController?.setViewControllers([tabBarController], animated: true)
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    override func loadView() {
        self.view = LaunchView(frame: UIScreen.main.bounds)
    }
}
