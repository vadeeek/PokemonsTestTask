import UIKit
import SnapKit

final class DetailsView: UIView {
    
    // MARK: - Properties
    
    // MARK: UIImageView
    private lazy var pokemonPicture: UIImageView = {
        let image = UIImage(named: "noImage4")
        let imageView = UIImageView(image: image)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var doubleArrow: UIImageView = {
        let image = UIImage(named: "doubleArrow")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: UILabel
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.text = "ID: "
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: UICollectionView
    lazy var detailsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.id)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
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
        backgroundColor = .systemGray
        addSubviews(pokemonPicture, doubleArrow, heightLabel, idLabel, detailsCollectionView)
    }
    
    func configureData(with pokemon: Pokemon) {
        if let id = pokemon.id, let height = pokemon.height {
            idLabel.text = "ID: \(id)"
        } else {
            idLabel.text = "ID: ?"
        }
        if let height = pokemon.height {
            heightLabel.text = "\(height)"
        } else {
            heightLabel.text = "?"
        }
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
        self.pokemonPicture.image = UIImage(data: data)
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        pokemonPicture.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(285)
        }
        
        doubleArrow.snp.makeConstraints { make in
            make.top.bottom.equalTo(pokemonPicture)
            make.centerX.equalTo(pokemonPicture.snp.trailing).offset(8)
        }
        
        idLabel.snp.makeConstraints { make in
            make.bottom.equalTo(pokemonPicture).offset(-5)
            make.leading.equalTo(pokemonPicture).offset(10)
        }
        
        heightLabel.snp.makeConstraints { make in
            make.leading.equalTo(doubleArrow.snp.centerX).offset(10)
            make.centerY.equalTo(doubleArrow)
        }
        
        detailsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pokemonPicture.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(270)
        }
    }
}
