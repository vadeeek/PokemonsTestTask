import UIKit
import SnapKit

final class DetailsView: UIView {
    
    // MARK: - Properties
    
    // MARK: UIImageView
    private lazy var pokemonPicture: UIImageView = {
        let image = UIImage(named: "noImage5")
        let imageView = UIImageView(image: image)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .purple
        
        return imageView
    }()
    
    // MARK: UILabel
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.text = "ID: "
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    private lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    // MARK: UICollectionView
    lazy var detailsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.id)
        collectionView.backgroundColor = .systemPink
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    lazy var evolutionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(EvolutionCell.self, forCellWithReuseIdentifier: EvolutionCell.id)
        collectionView.backgroundColor = .systemBlue
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 25
        collectionView.layer.maskedCorners = [.layerMinXMaxYCorner]
        collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "evolutionBG")!)
        collectionView.alpha = 0.85
        
        return collectionView
    }()
    
    // MARK: UIScrollView
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
//        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .red
        
        return scrollView
    }()
    
    // MARK: UIView
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        
        return view
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
        addSubviews(scrollView)
        scrollView.addSubviews(containerView)
        containerView.addSubviews(pokemonPicture, heightLabel, idLabel, detailsCollectionView, evolutionCollectionView)
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
            getPokemonPicture(pokemonID)
        }
        
        setUpPokemonAbilities(pokemon)
    }
    
    private func getPokemonPicture(_ pokemonID: Int) {
        APIManager.shared.getPokemonPicture(by: pokemonID) { [weak self] pokemonPictureData in
            guard let self else { return }
            DispatchQueue.main.async {
                self.setUpPokemonPicture(with: pokemonPictureData)
            }
        }
    }
    
    private func setUpPokemonPicture(with data: Data) {
        self.pokemonPicture.image = UIImage(data: data)
    }
    
    private func setUpPokemonAbilities(_ pokemon: Pokemon) {
        if let abilities = pokemon.abilities {
            for ability in abilities {
                print(ability.ability?.name)
            }
        }
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(3)
        }
        pokemonPicture.snp.makeConstraints { make in
            make.top.equalTo(containerView.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(containerView)
            make.height.width.equalTo(285)
        }
        idLabel.snp.makeConstraints { make in
            make.bottom.equalTo(pokemonPicture).offset(-5)
            make.leading.equalTo(pokemonPicture).offset(10)
        }
        heightLabel.snp.makeConstraints { make in
            make.leading.equalTo(pokemonPicture.snp.trailing).offset(10)
            make.centerY.equalTo(pokemonPicture)
        }
        detailsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pokemonPicture.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.13)
            make.centerX.equalTo(containerView)
            make.width.equalTo(270)
        }
        evolutionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(detailsCollectionView.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.leading.equalTo(containerView).offset(15)
            make.trailing.equalTo(containerView).offset(-15)
        }
    }
}
