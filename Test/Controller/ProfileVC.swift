import UIKit
import Firebase

final class ProfileVC: UIViewController {

    // MARK: - Properties
    private var unauthorizedProfileView = UnauthorizedProfileView(frame: UIScreen.main.bounds)
    private var authorizedProfileView = AuthorizedProfileView(frame: UIScreen.main.bounds)

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationControllerAppearance()
        
        unauthorizedProfileView.delegate = self
        authorizedProfileView.delegate = self
    }
    
    override func loadView() {
        if Auth.auth().currentUser != nil {
            self.view = authorizedProfileView
        } else {
            self.view = unauthorizedProfileView
        }
    }
    
    // MARK: - Methods
    private func setupNavigationControllerAppearance() {
        title = "Профиль"
        navigationItem.backButtonTitle = ""
        navigationItem.hidesBackButton = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemYellow // change navBar background color
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] // change navBar appearance settings
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - Extensions
// MARK: - UnauthorizedProfileViewDelegate
extension ProfileVC: UnauthorizedProfileViewDelegate {
    
    func createUser(withEmail email: String, andPassword password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Внимание!", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ок", style: .default)
                alertController.addAction(action)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Поздравляю!", message: "Вы успешно зарегистрированы!", preferredStyle: .alert)
                let action = UIAlertAction(title: "Войти (Запомнить меня ✅)", style: .default) { action in
                    print("Пользователь зарегистрирован!")
                    self.logIn(withEmail: email, andPassword: password, isRememberMe: true)
                }
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func logIn(withEmail email: String, andPassword password: String, isRememberMe: Bool) {
//        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
//
//        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if let error {
                let alertController = UIAlertController(title: "Внимание!", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ок", style: .default)
                alertController.addAction(action)
                
                self!.present(alertController, animated: true, completion: nil)
            } else {
                print("Вход выполнен успешно!")
                UserDefaults.standard.set(isRememberMe, forKey: "isRememberMe")
                // TODO: FIX "!"
                self!.view = self!.authorizedProfileView
            }
        }
    }
}

// MARK: - AuthorizedProfileViewDelegate
extension ProfileVC: AuthorizedProfileViewDelegate {
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "isRememberMe")
            print("3. \(UserDefaults.standard.bool(forKey: "isRememberMe"))")
            
            self.view = unauthorizedProfileView
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    func goToFavorites() {
        self.navigationController?.pushViewController(FavoritesVC(), animated: true)
    }
}
