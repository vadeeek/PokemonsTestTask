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
//    private lazy var arrowLogo: UIImageView = {
//        let image = UIImage(named: "arrow")
//        let imageView = UIImageView(image: image)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//
//        return imageView
//    }()
    
    private lazy var pokemonPicture: UIImageView = {
        let image = UIImage(named: "noImage4")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
//        imageView.backgroundColor = .red
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
        contentView.backgroundColor = .systemYellow
//        contentView.layer.borderColor = UIColor.black.cgColor
//        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 15
        contentView.addSubviews(pokemonPicture, nameLabel)
//        contentView.addSubviews(pokemonPicture, nameLabel, arrowLogo)
    }
    
//    private func setUpLayer() {
//        contentView.layer.cornerRadius = 8
//        contentView.layer.shadowColor = UIColor.secondaryLabel.cgColor
//        contentView.layer.shadowRadius = 4
//        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
//        contentView.layer.shadowOpacity = 0.3
//    }
    
    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name?.capitalized
        if let pokemonID = pokemon.id {
            APIManager.shared.getPokemonPicture(by: pokemonID) { [weak self] pokemonPictureData in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.setUpPokemonPicture(with: pokemonPictureData)
                }
            }
        }
    }
    
    private func setUpPokemonPicture(with data: Data) {
        pokemonPicture.contentMode = .scaleAspectFit
        pokemonPicture.clipsToBounds = false
        pokemonPicture.image = UIImage(data: data)
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        pokemonPicture.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
//        arrowLogo.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().offset(-20)
//            make.centerY.equalTo(self.snp.centerY)
//            make.height.equalTo(25)
//            make.width.equalTo(25)
//        }
    }
}
