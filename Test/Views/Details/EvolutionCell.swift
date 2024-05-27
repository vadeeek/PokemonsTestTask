import UIKit

final class EvolutionCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "evolution"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let currentLabel: UILabel = {
        let label = UILabel()
        label.text = "Current"
        label.textColor = .white
        label.backgroundColor = .red
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let pokemonPicture: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ""))
        imageView.layer.cornerRadius = 49
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
        imageView.backgroundColor = .brown
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 7, height: 5)
        imageView.layer.shadowOpacity = 0.3
        return imageView
    }()

    private let arrowImage: UIImageView = {
        let image = Resources.Images.DetailsScreen.evolutionArrow
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeConstraints()
        // DEBUG:
        debug()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupUI() {
//        contentView.backgroundColor = .magenta
        contentView.addSubviews(pokemonPicture, nameLabel, idLabel, arrowImage, currentLabel)
    }
    
    // DEBUG:
    private func debug() {
        contentView.backgroundColor = .magenta
    }
    
    func configure(evolutionCellModel: EvolutionCellModel) {
        self.nameLabel.text = evolutionCellModel.pokemon.name?.capitalized
        if let id = evolutionCellModel.pokemon.id {
            self.idLabel.text = "№ \(id)"
            let pictureUrlString = APIManager.shared.pokemonsImageUrlString + "\(id).png"
            pokemonPicture.sd_setImage(with: URL(string: pictureUrlString))
        }
        arrowImage.isHidden = evolutionCellModel.isLastEvolutionInChain
        currentLabel.isHidden = !evolutionCellModel.isCurrentEvolutionOnScreen
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(pokemonPicture)
            make.bottom.equalTo(idLabel.snp.top)
        }
        idLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView)
            make.centerX.equalTo(pokemonPicture)
        }
        pokemonPicture.snp.makeConstraints { make in
            make.width.height.equalTo(contentView.snp.width).multipliedBy(0.6)
            make.top.leading.equalTo(contentView)
        }
        arrowImage.snp.makeConstraints { make in
            make.leading.equalTo(pokemonPicture.snp.trailing).offset(17)
            make.centerY.equalTo(pokemonPicture)
            make.height.width.equalTo(pokemonPicture.snp.height).multipliedBy(0.25)
        }
        currentLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.4)
            make.height.equalTo(contentView).multipliedBy(0.15)
        }
    }
}
