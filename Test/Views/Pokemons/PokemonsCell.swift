import UIKit
import SnapKit
import SDWebImage

final class PokemonsCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "pokemons"
    
    private var pokemonTypes: [String] = []
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let pokemonPicture: UIImageView = {
        let image = Resources.Images.Pokemon.pokemonPictureNoImage
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .systemYellow
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    
    let pokemonTypesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonTypeCell.self, forCellWithReuseIdentifier: PokemonTypeCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let shortInfoFrame: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pokemonTypesCollectionView.dataSource = self
        pokemonTypesCollectionView.delegate = self
        
        setupUI()
        makeConstraints()
        // DEBUG:
//        debug()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.addSubviews(pokemonPicture, idLabel, shortInfoFrame, nameLabel,  pokemonTypesCollectionView)
    }
    
    // DEBUG:
    private func debug() {
        nameLabel.backgroundColor = .green
        idLabel.backgroundColor = .red
        pokemonTypesCollectionView.backgroundColor = .blue
    }
    
    func configure(with pokemon: EnhancedPokemon) {
        nameLabel.text = pokemon.name?.capitalized ?? "???"
        
        if let pokemonID = pokemon.id {
            idLabel.text = "\(pokemonID)"
            //            APIManager.shared.getPokemonPicture(by: pokemonID) { [weak self] pokemonPictureData in
//            if let pictureUrlString = pokemon.pictureUrlString {
            let pictureUrlString = APIManager.shared.pokemonsImageUrlString + "\(pokemonID).png"
            pokemonPicture.sd_setImage(with: URL(string: pictureUrlString)) { [weak self] _, _, _, _ in
                guard let self else { return }
                self.pokemonPicture.contentMode = .scaleAspectFit
                //        pokemonPicture.clipsToBounds = false
            }
        } else {
            idLabel.text = "???"
        }
        if let types = pokemon.types {
            for type in types {
                if let typeName = type.name {
                    DispatchQueue.main.async {
                        self.pokemonTypes.append(typeName)
                        self.pokemonTypesCollectionView.reloadData()
                    }
                }
            }
        }
        pokemonTypes.removeAll()
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        pokemonPicture.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).multipliedBy(0.75)
        }
        idLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalTo(self.snp.bottom).multipliedBy(0.875)
        }
        shortInfoFrame.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.snp.bottom).multipliedBy(0.78)
        }
        pokemonTypesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.snp.bottom).multipliedBy(0.86)
        }
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDataSource
extension PokemonsCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        pokemonTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonTypeCell.id, for: indexPath) as? PokemonTypeCell else { fatalError("Unsupported cell") }
        cell.configure(with: pokemonTypes[indexPath.row])
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension PokemonsCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds = collectionView.bounds.width
        let width = (bounds) / 1.5
        return CGSize(
            width: width,
            height: width / 4.6
        )
    }
}
