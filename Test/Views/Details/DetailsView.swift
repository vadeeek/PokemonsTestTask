import UIKit
import SnapKit

final class DetailsView: UIView {
    
    // MARK: - Properties
    weak var delegate: DetailsViewDelegate?
    
    private let pokemonPicture: UIImageView = {
        let image = Resources.Images.Pokemon.pokemonPictureNoImage
        let imageView = UIImageView(image: image)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.text = "ID: "
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    let detailsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.id)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    let evolutionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(EvolutionCell.self, forCellWithReuseIdentifier: EvolutionCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 25
        collectionView.layer.maskedCorners = [.layerMinXMaxYCorner]
        collectionView.backgroundColor = UIColor(patternImage: (Resources.Images.DetailsScreen.evolutionBG)!)
        collectionView.alpha = 0.85
        return collectionView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .yellow
        button.addTarget(self, action: #selector(starButtonPressed(_:)), for: .touchUpInside)
        return button
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
        backgroundColor = .systemGray
        addSubviews(scrollView)
        scrollView.addSubviews(containerView)
        containerView.addSubviews(pokemonPicture, heightLabel, idLabel, detailsCollectionView, evolutionCollectionView, starButton)
    }
    
    // DEBUG:
    private func debug() {
        pokemonPicture.backgroundColor = .purple
        scrollView.backgroundColor = .red
        containerView.backgroundColor = .green
        detailsCollectionView.backgroundColor = .systemPink
        starButton.backgroundColor = .red
    }
    
    func configureData(with pokemon: EnhancedPokemon) {
        if let id = pokemon.id, let height = pokemon.height { // FIXME: зачем здесь вторая проверка в условии??
            idLabel.text = "ID: \(id)"
        } else {
            idLabel.text = "ID: ?"
        }
        if let height = pokemon.height {
            heightLabel.text = "\(height)"
        } else {
            heightLabel.text = "?"
        }
        if let pictureUrlString = pokemon.pictureUrlString {
            setupPokemonPicture(with: URL(string: pictureUrlString))
        }
        setupPokemonAbilities(pokemon)
    }
    
    private func setupPokemonPicture(with url: URL?) {
        pokemonPicture.sd_setImage(with: url)
    }
    
    private func setupPokemonAbilities(_ pokemon: EnhancedPokemon) {
        if let abilities = pokemon.abilities {
            for ability in abilities {
                print(ability.name)
            }
        }
    }
    
    @objc private func starButtonPressed(_ sender: UIButton) {
        delegate?.updateFavoritePokemon()
//        delegate?.addToFavorites()
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
        starButton.snp.makeConstraints { make in
            make.trailing.top.equalTo(pokemonPicture)
            make.width.height.equalTo(pokemonPicture.snp.width).multipliedBy(0.25)
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
