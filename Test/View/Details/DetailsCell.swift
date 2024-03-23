import UIKit
import SnapKit

final class DetailsCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "details"
    
    // MARK: UILabel
    private let statTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
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
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 15
        contentView.addSubviews(statTitle, valueLabel)
    }
    
    func configureData(statTitle: String, value: Int) {
        self.statTitle.text = statTitle
        valueLabel.text = "\(value)"
    }
    
    func configureDataForCompare(statTitle: String, value: Int, id: Int) {
        contentView.backgroundColor = .clear
        contentView.layer.borderWidth = 0
        if id % 2 == 0 {
            self.statTitle.isHidden = false
            self.removeConstraints()
            self.makeConstraints()
        } else {
            self.statTitle.isHidden = true
            self.valueLabel.snp.removeConstraints()
            self.valueLabel.snp.makeConstraints { make in
                make.centerY.equalTo(self.snp.centerY)
                make.leading.equalToSuperview().offset(20)
            }
        }
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
    
    private func removeConstraints() {
        statTitle.snp.removeConstraints()
        valueLabel.snp.removeConstraints()
    }
}
