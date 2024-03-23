import UIKit

final class PokemonTypeCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "pokemonType"
    
    // MARK: UILabel
    private let typeLabel: UILabel = {
        let label = UILabel()
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
//        typeLabel.textColor = .black
        switch TypeFormatter.shared.formate(typeString: ability) {
        case (let typeString, let typeColor):
            switch typeColor {
            case .systemBlue, .darkGray, .black, .systemGray3, .purple:
                typeLabel.textColor = .white
            default:
                typeLabel.textColor = .black
                break
            }
            typeLabel.text = "\(typeString)"
            contentView.backgroundColor = typeColor
        }
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        typeLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
