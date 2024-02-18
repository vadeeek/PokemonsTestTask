import UIKit

final class DetailsVC: UIViewController {

    // MARK: - Properties
    var detailsView: DetailsView { return self.view as! DetailsView }
    
    private var pokemon: Pokemon
//    private var evolutionChainURLs: [String] = []
    private var pokemonEvolutionPictures: [Data] = []
    private var pokemonEvolutionsIDs: [Int] = []
    private var evolutionPokemons: [Pokemon] = []
    
    private let statsTitles = ["❤️ Health Points:", "⚔️ Attack:", "🛡️ Defense:", "🔥 Special Attack:", "🔮 Special Defense:", "💨 Speed:"]
    
    // MARK: - Life Cycle
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = pokemon.name?.uppercased()
        
        detailsView.detailsCollectionView.dataSource = self
        detailsView.detailsCollectionView.delegate = self
        detailsView.evolutionCollectionView.dataSource = self
        detailsView.evolutionCollectionView.delegate = self
        
        configureData()
        getEvolutionChain()
    }
    
    override func loadView() {
        self.view = DetailsView(frame: UIScreen.main.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemYellow // change navBar background color
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] // change navBar appearance settings
        
        navigationController?.navigationBar.tintColor = .black // change backButton color
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
//    override func viewDidLayoutSubviews() {
//        detailsView.evolutionCollectionView.roundCorners(topLeft: 10, topRight: 10, bottomLeft: 50, bottomRight: 10)
//    }
    
    private func configureData() {
        detailsView.configureData(with: pokemon)
    }
    
    private func getEvolutionChain() {
        guard let pokemonSpeciesURL = pokemon.species?.url else { return }
        APIManager.shared.getEvolutionChainArray(by: pokemonSpeciesURL) { chainArray in
            
//            DispatchQueue.main.async { [weak self] in
//                guard let self else { return }
//                self.evolutionChainURLs = chainArra
            var pokemonEvolutionsIDs: [Int] = []
            for element in chainArray {
                if let pokemonID = self.extractPokemonId(from: element) {
                    pokemonEvolutionsIDs.append(pokemonID)
                    self.pokemonEvolutionsIDs.append(pokemonID)
                }
            }
                self.getPokemonEvolutionPictures(from: pokemonEvolutionsIDs)
//            }
        }
    }
    
    private func extractPokemonId(from urlString: String) -> Int? {
        let components = urlString.components(separatedBy: "/")
        let filteredComponents = components.filter { !$0.isEmpty }

        print("components: \(filteredComponents)")
        for component in components {
            if let id = Int(component) {
                return id
            } else {
                continue
            }
        }
        return nil
    }

    private func getPokemonEvolutionPictures(from pokemonsIDsArray: [Int]) {
        APIManager.shared.getPokemonPicture(from: pokemonsIDsArray, completion: { [weak self] pokemonEvolutionPictures, pokemonIDsWithPicture in
            guard let self else { return }
            DispatchQueue.main.async {
                self.pokemonEvolutionPictures = pokemonEvolutionPictures
                self.pokemonEvolutionsIDs = pokemonsIDsArray
                
                // TODO: - APIManager.shared.getPokemons(from: pokemonEvolutionsIDs) ... {
                    self.detailsView.evolutionCollectionView.reloadData()
                // }
            }
        })
    }
    
}

// MARK: - Extensions
// MARK: - UICollectionViewDataSource
extension DetailsVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == detailsView.detailsCollectionView {
            if let count = pokemon.stats?.count {
                return count
            } else {
                return 0
            }
        } else if collectionView == detailsView.evolutionCollectionView {
            return pokemonEvolutionPictures.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == detailsView.detailsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCell.id, for: indexPath) as? DetailsCell else { fatalError("Unsupported cell") }
            
            guard let stat = pokemon.stats?[indexPath.row].baseStat else { return cell }
            cell.configureData(statTitle: statsTitles[indexPath.row], value: stat)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EvolutionCell.id, for: indexPath) as? EvolutionCell else { fatalError("Unsupported cell") }
            
            if indexPath.row == pokemonEvolutionPictures.count - 1 {
                cell.configure(with: pokemon, and: pokemonEvolutionPictures[indexPath.row], and: true)
            } else {
                cell.configure(with: pokemon, and: pokemonEvolutionPictures[indexPath.row], and: false)
            }
            return cell
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension DetailsVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == detailsView.detailsCollectionView {
            return CGSize(width: detailsView.detailsCollectionView.frame.width - 20, height: 40)
        } else {
            return CGSize(width: detailsView.evolutionCollectionView.frame.width / 2.3, height: detailsView.evolutionCollectionView.frame.width / 2.5)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == detailsView.detailsCollectionView {
            return 5
        } else {
            return 0
        }
    }
}

// MARK: - UICollectionViewDelegate
extension DetailsVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == detailsView.evolutionCollectionView {
            APIManager.shared.getPokemon(by: pokemonEvolutionsIDs[indexPath.row]) { pokemon in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    if let currentPokemonID = self.pokemon.id, let evolutionPokemonID = pokemon.id {
                        if currentPokemonID != evolutionPokemonID {
                            self.navigationController?.pushViewController(DetailsVC(pokemon: pokemon), animated: true)
                        }
                    }
                }
            }
        }
    }
}
