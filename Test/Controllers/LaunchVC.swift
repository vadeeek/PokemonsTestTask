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
            self.navigationController?.navigationBar.isHidden = true
            
            if var viewControllers = self.navigationController?.viewControllers {
                // Удаляем контроллер
                viewControllers = viewControllers.filter { !$0.isKind(of: LaunchVC.self) }
                
                // Добавляем новый контроллер в стек
                viewControllers.append(tabBarController)
                
                // Применяем измененный стек контроллеров
                self.navigationController?.setViewControllers(viewControllers, animated: true)
            }
        }
    }
    
    override func loadView() {
        self.view = LaunchView(frame: UIScreen.main.bounds)
    }
}
