import UIKit

final class DetailsCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "details"
    
    // MARK: UILabel
    private lazy var statTitle: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        
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
        contentView.backgroundColor = .systemYellow
//        contentView.backgroundColor = UIColor(red: 162/255, green: 166/255, blue: 255/255, alpha: 1)
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 15
        contentView.addSubviews(statTitle, valueLabel)
    }
    
    func configureData(statTitle: String, value: Int) {
        self.statTitle.text = statTitle
        valueLabel.text = "\(value)"
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        statTitle.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalToSuperview().offset(20)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
