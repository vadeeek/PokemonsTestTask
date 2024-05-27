import UIKit
import SnapKit

final class DetailsView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let cornerRadius: CGFloat = 15
    }
    
    // MARK: - Properties
    weak var delegate: DetailsViewDelegate?
    
    var pokemonTypes: [String] = []
    var pokemonAbilities: [String] = []
    
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
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let abilitiesLabel: UILabel = {
        let label = UILabel()
        label.text = "Abilities"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    let pokemonTypesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonTypeCell.self, forCellWithReuseIdentifier: PokemonTypeCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 5
        collectionView.backgroundColor = .systemGray
        return collectionView
    }()
    
    let pokemonAbilitiesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AbilityCell.self, forCellWithReuseIdentifier: AbilityCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 5
        collectionView.backgroundColor = .systemGray
        return collectionView
    }()
    
    let detailsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.id)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
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
    
    private let pokemonInfoFrame: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pokemonTypesCollectionView.dataSource = self
        pokemonTypesCollectionView.delegate = self
        pokemonAbilitiesCollectionView.dataSource = self
        pokemonAbilitiesCollectionView.delegate = self
        
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
        backgroundColor = .systemGray
        addSubviews(scrollView)
        scrollView.addSubviews(containerView)
        containerView.addSubviews(pokemonPicture, pokemonInfoFrame, pokemonTypesCollectionView, heightLabel, weightLabel, abilitiesLabel, pokemonAbilitiesCollectionView, idLabel, detailsCollectionView, evolutionCollectionView, starButton)
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
            heightLabel.text = "Height: \(Double(height)) m"
        } else {
            heightLabel.text = "Height: ? m"
        }
        if let weight = pokemon.weight {
            weightLabel.text = "Weight: \(Double(weight)) kg"
        } else {
            weightLabel.text = "Weight: ? kg"
        }
        if let pokemonID = pokemon.id {
            let pictureUrlString = APIManager.shared.pokemonsImageUrlString + "\(pokemonID).png"
            setupPokemonPicture(with: URL(string: pictureUrlString))
        }
        if let types = pokemon.types {
            for type in types {
                if let typeName = type.name {
                    pokemonTypes.append(typeName)
                }
            }
        }
        setupPokemonAbilities(pokemon)
    }
    
    private func setupPokemonPicture(with url: URL?) {
        pokemonPicture.sd_setImage(with: url)
    }
    
    private func setupPokemonAbilities(_ pokemon: EnhancedPokemon) {
        if let abilities = pokemon.abilities {
            for ability in abilities {
                if let abilityName = ability.name {
                    pokemonAbilities.append(abilityName)
                }
            }
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.pokemonAbilitiesCollectionView.reloadData()
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
        pokemonInfoFrame.snp.makeConstraints { make in
            make.top.equalTo(pokemonPicture.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.075)
            make.centerX.equalTo(containerView)
            make.width.equalTo(pokemonPicture)
        }
        pokemonTypesCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(pokemonInfoFrame).offset(5)
            make.trailing.equalTo(pokemonInfoFrame).offset(-5)
            make.top.equalTo(pokemonInfoFrame).offset(13)
            make.height.equalTo(pokemonInfoFrame).multipliedBy(0.145)
        }
        heightLabel.snp.makeConstraints { make in
            make.leading.equalTo(pokemonInfoFrame).offset(10)
            make.top.equalTo(pokemonTypesCollectionView.snp.bottom).offset(10)
        }
        weightLabel.snp.makeConstraints { make in
            make.leading.equalTo(pokemonInfoFrame).offset(10)
            make.top.equalTo(heightLabel.snp.bottom).offset(5)
        }
        abilitiesLabel.snp.makeConstraints { make in
            make.leading.equalTo(pokemonInfoFrame).offset(10)
            make.top.equalTo(weightLabel.snp.bottom).offset(10)
        }
        pokemonAbilitiesCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(pokemonInfoFrame).offset(5)
            make.trailing.equalTo(pokemonInfoFrame).offset(-5)
            make.top.equalTo(abilitiesLabel.snp.bottom).offset(10)
            make.bottom.equalTo(pokemonInfoFrame).offset(-5)
        }
        starButton.snp.makeConstraints { make in
            make.trailing.top.equalTo(pokemonPicture)
            make.width.height.equalTo(pokemonPicture.snp.width).multipliedBy(0.25)
        }
        idLabel.snp.makeConstraints { make in
            make.bottom.equalTo(pokemonPicture).offset(-5)
            make.leading.equalTo(pokemonPicture).offset(10)
        }
        detailsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pokemonAbilitiesCollectionView.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.13)
            make.centerX.equalTo(containerView)
            make.width.equalTo(270)
        }
        evolutionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(detailsCollectionView.snp.bottom).offset(5)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.leading.equalTo(containerView).offset(15)
            make.trailing.equalTo(containerView).offset(-15)
        }
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDataSource
extension DetailsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == pokemonTypesCollectionView {
            pokemonTypes.count
        } else {
            pokemonAbilities.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == pokemonTypesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonTypeCell.id, for: indexPath) as? PokemonTypeCell else { fatalError("Unsupported cell") }
            cell.configure(with: pokemonTypes[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AbilityCell.id, for: indexPath) as? AbilityCell else { fatalError("Unsupported cell") }
            cell.configure(with: pokemonAbilities[indexPath.row])
            return cell
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension DetailsView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == pokemonTypesCollectionView {
            let bounds = collectionView.bounds.width
            let width = (bounds) / 2.5
            return CGSize(
                width: width,
                height: width / 4.6
            )
        } else {
            let bounds = collectionView.bounds.width
            let width = bounds
            return CGSize(
                width: width,
                height: width / 15
            )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView != pokemonTypesCollectionView {
            return 0.0
        } else {
            return 10.0
        }
    }
}
