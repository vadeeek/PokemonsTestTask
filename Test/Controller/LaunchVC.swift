import UIKit

final class LaunchVC: UIViewController {
    
    // MARK: - Properties
    var launchView: LaunchView { return self.view as! LaunchView }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigationController?.pushViewController(MainVC(), animated: true)
        }
    }
    
    override func loadView() {
        self.view = LaunchView(frame: UIScreen.main.bounds)
    }
}
