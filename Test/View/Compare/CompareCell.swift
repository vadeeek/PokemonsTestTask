import UIKit
import SnapKit
import SDWebImage

final class CompareCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "compare"
    
    private var currentPokemon: EnhancedPokemon?
    private var selectedPokemonID: Int?
    private var pokemonTypes: [String] = []
    private let statsTitles = ["❤️ Health:", "⚔️ Attack (A):", "🛡️ Defense (D):", "🔥 Special (A):", "🔮 Special (D):", "💨 Speed:"]
    
    // MARK: UILabel
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
    
    // MARK: UIImageView
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
    
    // MARK: UICollectionView
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
    
    let characteristicsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.id)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: UIView
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
        characteristicsCollectionView.dataSource = self
        characteristicsCollectionView.delegate = self
        
        setupUI()
        makeConstraints()
        // DEBUG:
        debug()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        //        contentView.layer.cornerRadius = 15
        contentView.addSubviews(pokemonPicture, idLabel, shortInfoFrame, nameLabel,  pokemonTypesCollectionView, characteristicsCollectionView)
    }
    
    // DEBUG:
    private func debug() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
//        nameLabel.backgroundColor = .systemPink
//        pokemonTypesCollectionView.backgroundColor = .green
//        characteristicsCollectionView.backgroundColor = .systemGray
    }
    
    func configureData(with pokemon: EnhancedPokemon, id: Int) {
        self.currentPokemon = pokemon
        self.selectedPokemonID = id
        nameLabel.text = pokemon.name?.capitalized ?? "???"
        
        if let pokemonID = pokemon.id {
            idLabel.text = "\(pokemonID)"
            //            APIManager.shared.getPokemonPicture(by: pokemonID) { [weak self] pokemonPictureData in
            if let pictureUrlString = pokemon.pictureUrlString {
                pokemonPicture.sd_setImage(with: URL(string: pictureUrlString)) { [weak self] _, _, _, _ in
                    guard let self else { return }
                    self.pokemonPicture.contentMode = .scaleAspectFit
                    //        pokemonPicture.clipsToBounds = false
                }
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
    
    //    private func setUpPokemonPicture(with data: Data) {
    //        pokemonPicture.contentMode = .scaleAspectFit
    ////        pokemonPicture.clipsToBounds = false
    //        pokemonPicture.image = UIImage(data: data)
    //    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        pokemonPicture.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(1.3)
        }
        idLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
        }
        shortInfoFrame.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(0.4)
            make.top.equalTo(pokemonPicture.snp.bottom).offset(5)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(shortInfoFrame).offset(5)
            make.height.equalTo(shortInfoFrame.snp.height).multipliedBy(0.3)
        }
        pokemonTypesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.height.equalTo(shortInfoFrame.snp.height).multipliedBy(0.5)
        }
        characteristicsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pokemonTypesCollectionView.snp.bottom).offset(20)
//            make.height.equalToSuperview().multipliedBy(0.42)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDataSource
extension CompareCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == characteristicsCollectionView {
            if let count = currentPokemon?.stats?.count {
                return count
            } else {
                return 0
            }
        } else {
            return pokemonTypes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == characteristicsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCell.id, for: indexPath) as? DetailsCell else { fatalError("Unsupported cell") }
            
            guard let stat = currentPokemon?.stats?[indexPath.row].baseStat else { return cell }
            if let id = self.selectedPokemonID {
                cell.configureCell(with: .compare(statTitle: statsTitles[indexPath.row], value: stat, selectedPokemonID: id, statID: indexPath.row))
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonTypeCell.id, for: indexPath) as? PokemonTypeCell else { fatalError("Unsupported cell") }
            let pokemonTypeName = pokemonTypes[indexPath.row]
            cell.configure(with: pokemonTypeName)
            return cell
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension CompareCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == characteristicsCollectionView {
            return CGSize(width: characteristicsCollectionView.frame.width, height: 40)
        } else {
            let bounds = collectionView.bounds.width
            let width = (bounds) / 1.5
            return CGSize(
                width: width,
                height: width / 4.6
            )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == characteristicsCollectionView {
            return 5
        } else {
            return 10
        }
    }
}
