import UIKit

final class ItemsAllCategoriesCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "itemsAllCategories"
    
    private let categoryLabel: UILabel = {
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
        contentView.alpha = 0.5
        contentView.layer.cornerRadius = 10
        contentView.addSubviews(categoryLabel)
    }
    
    func configure(with category: String) {
        let formattedCategoryString = TypeFormatter.shared.format(type: .itemCategory(string: category))
        categoryLabel.text = "\(formattedCategoryString)"
        
        if let color = TypeFormatter.shared.categoryColors[category] {
            let textColor = color.isDark ? UIColor.white : UIColor.black
            categoryLabel.textColor = textColor
            contentView.backgroundColor = color
        } else {
            categoryLabel.textColor = .white
            contentView.backgroundColor = .systemGray
        }
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
