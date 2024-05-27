import UIKit

final class AbilityCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "ability"
    
    private let abilityLabel: UILabel = {
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
    
    // MARK: - Methods
    private func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.addSubviews(abilityLabel)
    }
    
    func configure(with ability: String) {
        switch TypeFormatter.shared.formate(typeString: ability) {
        case (let typeString, _):
            abilityLabel.text = "\(typeString)"
        }
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        abilityLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
        }
    }
}
