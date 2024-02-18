import UIKit

final class EvolutionCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "evolution"
    
    // MARK: UILabel
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }()
    
    // MARK: UIImageView
    private lazy var pokemonPicture: UIImageView = {
        let image = UIImage(named: "")
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 49
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
        imageView.backgroundColor = .brown
        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
        
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 7, height: 5)
//        contentView.layer.shadowRadius = CGSize(width: <#T##Double#>, height: <#T##Double#>)
        imageView.layer.shadowOpacity = 0.3
        
        return imageView
    }()
    
    private lazy var arrowImage: UIImageView = {
        let image = UIImage(named: "arrow")
        let imageView = UIImageView(image: image)

//        imageView.layer.shadowColor = UIColor.black.cgColor
//        imageView.layer.shadowOffset = CGSize(width: 7, height: 5)
//        contentView.layer.shadowRadius = CGSize(width: <#T##Double#>, height: <#T##Double#>)
//        imageView.layer.shadowOpacity = 0.3
        
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
        contentView.backgroundColor = .magenta
//        contentView.backgroundColor = UIColor(red: 162/255, green: 166/255, blue: 255/255, alpha: 1)
//        contentView.layer.borderColor = UIColor.white.cgColor
//        contentView.layer.borderWidth = 4
//        contentView.layer.cornerRadius = 49
        
        // shadow
//        contentView.layer.shadowColor = UIColor.black.cgColor
//        contentView.layer.shadowOffset = CGSize(width: 7, height: 5)
//        contentView.layer.shadowRadius = CGSize(width: <#T##Double#>, height: <#T##Double#>)
//        contentView.layer.shadowOpacity = 0.3
        
        contentView.addSubviews(pokemonPicture, nameLabel, idLabel, arrowImage)
    }
    
    func configure(with pokemon: Pokemon, and pokemonEvolutionPicture: Data, and isLastPokemonFlag: Bool) {
//        dsadas
//        передавать сюда айдишники покемонов из эволюции чтобы отображать их инфу и подгружать потом при тапе на эволюцию и переходе на новый экран
        self.nameLabel.text = pokemon.name?.capitalized
        if let id = pokemon.id {
            self.idLabel.text = "№ \(id)"
        }
        
        pokemonPicture.image = UIImage(data: pokemonEvolutionPicture)
        
        if isLastPokemonFlag {
            arrowImage.isHidden = true
        }
        
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
    }
}
