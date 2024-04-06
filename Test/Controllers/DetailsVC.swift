import UIKit
import Firebase // FIX

final class DetailsVC: UIViewController {
    
    // MARK: - Properties
    var detailsView: DetailsView { return self.view as! DetailsView }
    
    private var currentPokemon: EnhancedPokemon
    private var evolutionPokemons: [EnhancedPokemon] = []
    private var pokemonEvolutionsIDs: [Int] = []
    
    private let statsTitles = ["❤️ Health Points:", "⚔️ Attack:", "🛡️ Defense:", "🔥 Special Attack:", "🔮 Special Defense:", "💨 Speed:"]
    
    // MARK: - Life Cycle
    init(pokemon: EnhancedPokemon) {
        self.currentPokemon = pokemon
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = DetailsView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("currentPokemon: \(currentPokemon)")
        
        title = currentPokemon.name?.uppercased()
        addCompareButton()
        
        detailsView.detailsCollectionView.dataSource = self
        detailsView.detailsCollectionView.delegate = self
        detailsView.evolutionCollectionView.dataSource = self
        detailsView.evolutionCollectionView.delegate = self
        
        detailsView.delegate = self
        
        configureData()
        getEvolutionChain()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationControllerAppearance()
    }
    
    private func setupNavigationControllerAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemYellow // change navBar background color
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] // change navBar appearance settings
        
        navigationController?.navigationBar.tintColor = .black // change backButton color
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func addCompareButton() {
        let rightButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(compareButtonTapped(_:)))
        rightButton.title = "Compare"
        rightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func compareButtonTapped(_ sender: UIBarButtonItem) {
        ComparePokemonsManager.shared.addPokemon(currentPokemon)
        
        // TODO: - FIX
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            // userID содержит идентификатор текущего пользователя
            print("User ID: \(userID)")
        } else {
            // Пользователь не аутентифицирован
            print("User is not authenticated")
        }
    }
    
    private func configureData() {
        detailsView.configureData(with: currentPokemon)
    }
    
    private func getEvolutionChain() {
        guard let pokemonSpeciesURL = currentPokemon.species?.url else { return }
        APIManager.shared.getEvolutionChainArray(byUrlString: pokemonSpeciesURL) { result in
            switch result {
            case .success(let chainArray):
                var pokemonEvolutionsIDs: [Int] = []
                for element in chainArray {
                    if let pokemonID = self.extractPokemonId(from: element) {
                        pokemonEvolutionsIDs.append(pokemonID)
                        self.pokemonEvolutionsIDs.append(pokemonID)
                    }
                }
                self.getEvolutionPokemons(from: pokemonEvolutionsIDs)
            case .failure(_):
                print("No evolution data!")
            }
        }
    }
    
    private func extractPokemonId(from urlString: String) -> Int? {
        let components = urlString.components(separatedBy: "/")
        _ = components.filter { !$0.isEmpty }
        
        for component in components {
            if let id = Int(component) {
                return id
            } else {
                continue
            }
        }
        return nil
    }
    
    private func getEvolutionPokemons(from pokemonsIDsArray: [Int]) {
        APIManager.shared.getPokemonsForEvolution(fromPokemonIDsArray: pokemonsIDsArray) { [weak self] result in
            switch result {
            case .success((let evolutionPokemons, let pokemonsEvolutionsIDs)):
                DispatchQueue.main.async {
                    guard let self else { return }
                    self.evolutionPokemons = evolutionPokemons
                    self.pokemonEvolutionsIDs = pokemonsEvolutionsIDs
                    self.detailsView.evolutionCollectionView.reloadData()
                }
            case .failure(_):
                print("No evolution data!")
            }
        }
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDataSource
extension DetailsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == detailsView.detailsCollectionView {
            if let count = currentPokemon.stats?.count {
                return count
            } else {
                return 0
            }
        } else if collectionView == detailsView.evolutionCollectionView {
            return evolutionPokemons.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == detailsView.detailsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCell.id, for: indexPath) as? DetailsCell else { fatalError("Unsupported cell") }
            
            guard let stat = currentPokemon.stats?[indexPath.row].baseStat else { return cell }
            cell.configureCell(with: .details(statTitle: statsTitles[indexPath.row], value: stat))
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EvolutionCell.id, for: indexPath) as? EvolutionCell else { fatalError("Unsupported cell") }
            
            // TODO: - Зарефакторить код чтобы было меньше повторяющегося кода, вынести проверки в отдельные переменные и потои одной строкой формировать модель
            if indexPath.row == evolutionPokemons.count - 1 {
                if let currentPokemonID = self.currentPokemon.id {
                    if currentPokemonID != pokemonEvolutionsIDs[indexPath.row] {
                        cell.configure(evolutionCellModel: EvolutionCellModel(
                            pokemon: evolutionPokemons[indexPath.row],
                            isLastEvolutionInChain: true,
                            isCurrentEvolutionOnScreen: false)
                        )
                    } else {
                        cell.configure(evolutionCellModel: EvolutionCellModel(
                            pokemon: evolutionPokemons[indexPath.row],
                            isLastEvolutionInChain: true,
                            isCurrentEvolutionOnScreen: true))
                    }
                }
            } else {
                if let currentPokemonID = self.currentPokemon.id {
                    if currentPokemonID != pokemonEvolutionsIDs[indexPath.row] {
                        cell.configure(evolutionCellModel: EvolutionCellModel(
                            pokemon: evolutionPokemons[indexPath.row],
                            isLastEvolutionInChain: false,
                            isCurrentEvolutionOnScreen: false)
                        )
                    } else {
                        cell.configure(evolutionCellModel: EvolutionCellModel(
                            pokemon: evolutionPokemons[indexPath.row],
                            isLastEvolutionInChain: false,
                            isCurrentEvolutionOnScreen: true))
                    }
                }
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
            APIManager.shared.getPokemon(byID: pokemonEvolutionsIDs[indexPath.row]) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let pokemon):
                    DispatchQueue.main.async {
                        if let currentPokemonID = self.currentPokemon.id, let evolutionPokemonID = pokemon.id {
                            if currentPokemonID != evolutionPokemonID {
                                self.navigationController?.pushViewController(DetailsVC(pokemon: pokemon), animated: true)
                            }
                        }
                    }
                case .failure(_):
                    print("No pokemon data!")
                }
            }
        }
    }
}

// MARK: - DetailsViewDelegate
extension DetailsVC: DetailsViewDelegate {
    
    func updateFavoritePokemon() {
        FirebaseManager.shared.updateFavoritePokemon(pokemon: currentPokemon, from: self)
    }
}
