import UIKit

class MainPokemonTypeCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "mainPokemonType"
    
    // MARK: UILabel
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        
        return label
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
        contentView.layer.cornerRadius = 10
        contentView.addSubviews(typeLabel)
    }
    
    func configure(with ability: String) {
        typeLabel.textColor = .black
        switch TypeFormatter.shared.formate(typeString: ability) {
        case (let typeString, let color):
            switch color {
            case .systemBlue, .darkGray, .black, .systemGray3, .purple:
                typeLabel.textColor = .white
            default:
                break
            }
            typeLabel.text = "\(typeString)"
            contentView.backgroundColor = color
        }
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        typeLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
