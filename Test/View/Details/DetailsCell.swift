import UIKit

class DetailsCell: UICollectionViewCell {
    
    static let id = "details"
    
    // MARK: UILabel
    let statTitle: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(contentView)
        self.backgroundColor = UIColor(red: 162/255, green: 166/255, blue: 255/255, alpha: 1)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 15
        contentView.addSubview(statTitle)
        contentView.addSubview(valueLabel)
    }
    
    func configureData(statTitle: String, value: Int) {
        self.statTitle.text = statTitle
        self.valueLabel.text = "\(value)"
    }
    
    func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
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
