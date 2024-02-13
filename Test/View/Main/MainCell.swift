import UIKit
import SnapKit

final class MainCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "main"
    
    // MARK: UILabel
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: UIImageView
    private lazy var arrowLogo: UIImageView = {
        let image = UIImage(named: "arrow")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(contentView)
        self.backgroundColor = UIColor(red: 162/255, green: 166/255, blue: 255/255, alpha: 1)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 15
        contentView.addSubview(nameLabel)
        contentView.addSubview(arrowLogo)
    }
    
    func setPokemon(name: String?) {
        nameLabel.text = name
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalToSuperview().offset(30)
        }
        
        arrowLogo.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
    }
}
