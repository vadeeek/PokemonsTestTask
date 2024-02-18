import UIKit
import SnapKit

final class MainCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "main"
    
    private var pokemonTypes: [String] = []
    
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
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    // MARK: UIImageView
//    private lazy var arrowLogo: UIImageView = {
//        let image = UIImage(named: "arrow")
//        let imageView = UIImageView(image: image)
//
//        return imageView
//    }()
    
    private lazy var pokemonPicture: UIImageView = {
        let image = UIImage(named: "noImage5")
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .systemYellow
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return imageView
    }()
    
    // MARK: UICollectionView
    lazy var pokemonTypesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MainPokemonTypeCell.self, forCellWithReuseIdentifier: MainPokemonTypeCell.id)
        collectionView.backgroundColor = .clear
//        collectionView.alpha = 1.0
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    // MARK: UIView
    private lazy var shortInfoFrame: UIView = {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.addSubviews(pokemonPicture, idLabel, shortInfoFrame, nameLabel,  pokemonTypesCollectionView)
    }
    
    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name?.capitalized
        
        if let pokemonID = pokemon.id {
            idLabel.text = "\(pokemonID)"
//            APIManager.shared.getPokemonPicture(by: pokemonID) { [weak self] pokemonPictureData in
            if let pokemonPictureURLString = pokemon.sprites?.frontDefault {
//                APIManager.shared.loadImageFromURL(url: URL(string: pokemonPictureURLString)!) { image in
//                        DispatchQueue.main.async {
//                            if let image = image {
//                                self.setUpPokemonPicture(with: image)
//                            } else {
//                                print("PIZDA")
//                            }
//                        }
//                    }

                APIManager.shared.getPokemonPicture(by: pokemonPictureURLString) { [weak self] pokemonPictureData in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        self.setUpPokemonPicture(with: pokemonPictureData)
                    }
                }
            }
        } else {
            idLabel.text = "???"
        }
        
        if let types = pokemon.types {
            for type in types {
                if let typeName = type.type?.name {
                    DispatchQueue.main.async {
                        self.pokemonTypes.append(typeName)
                        self.pokemonTypesCollectionView.reloadData()
                    }
                }
            }
        }
        pokemonTypes.removeAll()
    }
    
    private func setUpPokemonPicture(with data: Data) {
        pokemonPicture.contentMode = .scaleAspectFit
//        pokemonPicture.clipsToBounds = false
        pokemonPicture.image = UIImage(data: data)
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
//        arrowLogo.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().offset(-20)
//            make.centerY.equalTo(self.snp.centerY)
//            make.height.equalTo(25)
//            make.width.equalTo(25)
//        }
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDataSource
extension MainCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        pokemonTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPokemonTypeCell.id, for: indexPath) as? MainPokemonTypeCell else { fatalError("Unsupported cell") }
        let pokemonTypeName = pokemonTypes[indexPath.row]
        cell.configure(with: pokemonTypeName)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MainCell: UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let viewController = DetailsVC(pokemon: pokemonsData[indexPath.row])
//        viewController.title = pokemonsData[indexPath.row].name?.uppercased()
//        navigationController?.pushViewController(viewController, animated: true)
//    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension MainCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        let bounds = collectionView.bounds.width
        let width = (bounds) / 1.5
        return CGSize(
            width: width,
            height: width / 4.6
        )
    }
}
