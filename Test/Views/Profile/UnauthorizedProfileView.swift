import UIKit

final class UnauthorizedProfileView: UIView {

    // MARK: - Properties
    enum AuthenticationMode {
        case registration
        case authorization
    }
    
    weak var delegate: UnauthorizedProfileViewDelegate?
    
    private var authenticationMode: AuthenticationMode = .authorization
    
    let noAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 11)
        return label
    }()
    
    lazy var changeAuthModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(changeAuthModeButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var authenticationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(logIn(_:)), for: .touchUpInside)
        return button
    }()
    
    let loginTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .systemGray
        tf.textColor = .black
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        tf.placeholder = "myname@example.com"
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .systemGray
        tf.textColor = .black
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        tf.placeholder = ""
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .systemGray
        tf.textColor = .black
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        tf.placeholder = ""
        tf.isSecureTextEntry = true
        tf.isHidden = true
        return tf
    }()
    
    let rememberMeLabel: UILabel = {
        let label = UILabel()
        label.text = "Remember me"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 11)
        return label
    }()
    
    let rememberMeSwitch: UISwitch = {
        let tumbler = UISwitch()
        return tumbler
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeConstraints()
        // DEBUG:
        debug()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupUI() {
        backgroundColor = .white
        addSubviews(loginTextField, passwordTextField, confirmPasswordTextField, rememberMeLabel, rememberMeSwitch, authenticationButton, noAccountLabel, changeAuthModeButton)
    }
    // DEBUG:
    private func debug() {
        noAccountLabel.backgroundColor = .green
        changeAuthModeButton.backgroundColor = .red
        rememberMeLabel.backgroundColor = .yellow
        rememberMeSwitch.backgroundColor = .orange
    }
    
    @objc private func changeAuthModeButtonPressed(_ sender: UIButton) {
        if authenticationMode == .authorization {
            authenticationMode = .registration
            noAccountLabel.text = "Have an account?"
            changeAuthModeButton.setTitle("Log In", for: .normal)
            authenticationButton.setTitle("Sign up", for: .normal)
            authenticationButton.addTarget(self, action: #selector(createAccount(_:)), for: .touchUpInside)
            confirmPasswordTextField.isHidden = false
            rememberMeLabel.isHidden = true
            rememberMeSwitch.isHidden = true
        } else {
            authenticationMode = .authorization
            noAccountLabel.text = "Don't have an account?"
            changeAuthModeButton.setTitle("Sign up", for: .normal)
            authenticationButton.setTitle("Log In", for: .normal)
            authenticationButton.addTarget(self, action: #selector(logIn(_:)), for: .touchUpInside)
            confirmPasswordTextField.isHidden = true
            rememberMeLabel.isHidden = false
            rememberMeSwitch.isHidden = false
        }
        loginTextField.text = nil
        passwordTextField.text = nil
        confirmPasswordTextField.text = nil
    }
    
    @objc private func createAccount(_ sender: UIButton) {
        if let email = loginTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text, password == confirmPassword, authenticationMode == .registration {
            delegate?.createUser(withEmail: email, andPassword: password)
        }
    }
    
    @objc private func logIn(_ sender: UIButton) {
        if let email = loginTextField.text, let password = passwordTextField.text, authenticationMode == .authorization {
            delegate?.logIn(withEmail: email, andPassword: password, isRememberMe: rememberMeSwitch.isOn)
        }
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        loginTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).offset(100)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalTo(loginTextField)
            make.top.equalTo(loginTextField.snp.bottom).offset(20)
            make.width.equalTo(loginTextField)
        }
        confirmPasswordTextField.snp.makeConstraints { make in
            make.centerX.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.width.equalTo(loginTextField)
        }
        rememberMeLabel.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
        }
        rememberMeSwitch.snp.makeConstraints { make in
            make.leading.equalTo(rememberMeLabel.snp.trailing).offset(20)
            make.centerY.equalTo(rememberMeLabel)
        }
        authenticationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(30)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        noAccountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-160)
        }
        changeAuthModeButton.snp.makeConstraints { make in
            make.leading.equalTo(noAccountLabel.snp.trailing).offset(3)
            make.centerY.equalTo(noAccountLabel)
        }
    }
}

extension UnauthorizedProfileView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == confirmPasswordTextField, textField.text == passwordTextField.text {
            print("Пароли совпадают!")
        }
    }
}
