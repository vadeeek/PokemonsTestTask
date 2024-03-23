import Foundation

protocol UnauthorizedProfileViewDelegate: AnyObject {
    
    func createUser(withEmail email: String, andPassword password: String)
    func logIn(withEmail email: String, andPassword password: String, isRememberMe: Bool)
}
