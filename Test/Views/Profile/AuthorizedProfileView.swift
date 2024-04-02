import UIKit

final class AuthorizedProfileView: UIView {

    // MARK: - Properties
    weak var delegate: AuthorizedProfileViewDelegate?
    
    let changeLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "Смена языка"
        label.backgroundColor = .systemYellow
        label.clipsToBounds = true
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var ruLanguageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🇷🇺\n✅", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 58)
//        button.addTarget(self, action: #selector(signOutButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var enLanguageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🇺🇸\n✅", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 58)
//        button.addTarget(self, action: #selector(signOutButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(signOutButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.setTitle("Favorites", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(favoritesButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private let languageFrame: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 10
        return view
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
    
    let rememberMeLabel: UILabel = {
        let label = UILabel()
        label.text = "Remember me"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 11)
        return label
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeConstraints()
        // DEBUG:
//        debug()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupUI() {
        backgroundColor = .systemGreen
        addSubviews(languageFrame, ruLanguageButton, enLanguageButton, favoritesButton, signOutButton)
        languageFrame.addSubviews(changeLanguageLabel)
    }
    // DEBUG:
    private func debug() {
        ruLanguageButton.backgroundColor = .orange
        enLanguageButton.backgroundColor = .red
//        rememberMeLabel.backgroundColor = .yellow
//        rememberMeSwitch.backgroundColor = .orange
    }
    
    @objc private func signOutButtonPressed(_ sender: UIButton) {
        delegate?.signOut()
    }
    
    @objc private func favoritesButtonPressed(_ sender: UIButton) {
        delegate?.goToFavorites()
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        languageFrame.snp.makeConstraints { make in
            make.top.equalTo(self.snp.centerY)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(120)
        }
        changeLanguageLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(languageFrame)
            make.bottom.equalTo(ruLanguageButton.snp.top)
        }
        ruLanguageButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(languageFrame)
            make.trailing.equalTo(languageFrame.snp.centerX)
            make.top.equalTo(languageFrame).offset(30)
        }
        enLanguageButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(languageFrame)
            make.leading.equalTo(languageFrame.snp.centerX)
            make.top.equalTo(languageFrame).offset(30)
        }
        favoritesButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(signOutButton.snp.top).offset(-30)
            make.height.equalTo(40)
        }
        signOutButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(30)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-35)
            make.centerX.equalToSuperview()
        }
    }
}
