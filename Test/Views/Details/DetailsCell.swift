import UIKit
import SnapKit

final class DetailsCell: UICollectionViewCell {
    
    // MARK: - Enums
    enum CellConfigurationMode {
        case details(statTitle: String, value: Int)
        case compare(statTitle: String, value: Int, selectedPokemonID: Int, statID: Int)
    }
    
    // MARK: - Constants
    private enum Constants {
        static let statTitleFontSizeDetails: CGFloat = 18
        static let valueLabelFontSizeDetails: CGFloat = 18
        static let statTitleFontSizeCompare: CGFloat = 14
        static let valueLabelFontSizeCompare: CGFloat = 16
        static let valueLabelFontSizeArrowShown: CGFloat = 20
        static let bgColor = UIColor.systemYellow
        static let compareArrowColor = UIColor.green
        static let compareArrowSystemName = "arrow.up"
        static let borderColor = UIColor.black.cgColor
        static let borderWidth: CGFloat = 2
        static let cornerRadius: CGFloat = 15
    }
    
    // MARK: - Properties
    static let id = "details"
    
    private let statTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let compareArrow: UIImageView = {
        let iv = UIImageView(image: UIImage())
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeConstraints()
        debug()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupUI() {
        contentView.backgroundColor = Constants.bgColor
        contentView.layer.borderColor = Constants.borderColor
        contentView.layer.borderWidth = Constants.borderWidth
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.addSubviews(statTitle, valueLabel, compareArrow)
    }
    
    // DEBUG:
    private func debug() {
//        compareArrow.backgroundColor = .white
    }
    
    func configureCell(with mode: CellConfigurationMode) {
        switch mode {
        case .details(let statTitle, let value):
            configureUIComponents(for: .details(statTitle: statTitle, value: value))
        case .compare(let statTitle, let value, let selectedPokemonID, let statID):
            configureUIComponents(for: .compare(statTitle: statTitle, value: value, selectedPokemonID: selectedPokemonID, statID: statID))
            configureForCompare(statTitle: statTitle, value: value, selectedPokemonID: selectedPokemonID, statID: statID)
        }
    }

    private func configureUIComponents(for mode: CellConfigurationMode) {
        switch mode {
        case .details(let statTitle, let value):
            compareArrow.isHidden = true
            self.statTitle.font = .boldSystemFont(ofSize: Constants.statTitleFontSizeDetails)
            self.statTitle.text = statTitle
            valueLabel.font = .systemFont(ofSize: Constants.valueLabelFontSizeDetails, weight: .semibold)
            valueLabel.text = "\(value)"
        case .compare(let statTitle, let value, _, _):
            compareArrow.isHidden = true
            contentView.backgroundColor = .clear
            contentView.layer.borderWidth = 0
            self.statTitle.font = .boldSystemFont(ofSize: Constants.statTitleFontSizeCompare)
            self.statTitle.text = statTitle
            valueLabel.font = .systemFont(ofSize: Constants.valueLabelFontSizeCompare, weight: .semibold)
            valueLabel.text = "\(value)"
        }
    }
    
    private func configureForCompare(statTitle: String, value: Int, selectedPokemonID: Int, statID: Int) {
        guard let attributeWinner = ComparePokemonsManager.shared.selectedPokemonsAttributesWinner.indices.contains(statID) ? ComparePokemonsManager.shared.selectedPokemonsAttributesWinner[statID] : nil else { return }
        if shouldHighlightAttributeWinner(selectedPokemonID: selectedPokemonID, attributeWinner: attributeWinner) {
            highlightWinningStat()
        }
    }

    private func shouldHighlightAttributeWinner(selectedPokemonID: Int, attributeWinner: AttributeWinner) -> Bool {
        selectedPokemonID % 2 == 0 ? attributeWinner == .left : attributeWinner == .right
    }

    private func highlightWinningStat() {
        valueLabel.font = .systemFont(ofSize: Constants.valueLabelFontSizeArrowShown, weight: .semibold)
        configureArrow()
    }

    private func configureArrow() {
        compareArrow.isHidden = false
        if let symbolImage = UIImage(systemName: Constants.compareArrowSystemName),
            let boldSymbolImage = applyBoldConfiguration(to: symbolImage) {
            compareArrow.image = boldSymbolImage
        }
        compareArrow.tintColor = Constants.compareArrowColor
    }

    private func applyBoldConfiguration(to image: UIImage) -> UIImage? {
        let config = UIImage.SymbolConfiguration(weight: .bold)
        return image.withConfiguration(config)
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        statTitle.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalToSuperview().offset(5)
        }
        valueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(compareArrow.snp.leading).offset(-4)
            make.centerY.equalTo(self.snp.centerY)
        }
        compareArrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-3)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalToSuperview().multipliedBy(0.11)
        }
    }
}
