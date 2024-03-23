import UIKit

final class FavoritesVC: UIViewController {
    
    //MARK: - Properties
    private var favoritesView: FavoritesView { return self.view as! FavoritesView }

    private var pokemonsData: [EnhancedPokemon] = []
    private var filteredPokemonsData: [EnhancedPokemon] = []
    private var allPokemonTypes: [String] = []
    private var selectedCells: [IndexPath: CGFloat] = [:]

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAllPokemonTypes()
        fetchFavoritePokemons()

        favoritesView.pokemonsCollectionView.dataSource = self
        favoritesView.pokemonsCollectionView.delegate = self
        favoritesView.pokemonTypesCollectionView.dataSource = self
        favoritesView.pokemonTypesCollectionView.delegate = self
    }

    override func loadView() {
        self.view = FavoritesView(frame: UIScreen.main.bounds)
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigationControllerAppearance()
    }

    private func setupNavigationControllerAppearance() {
        title = "Favorites"
        navigationItem.backButtonTitle = ""
        navigationItem.hidesBackButton = true

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemYellow // change navBar background color
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] // change navBar appearance settings
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

        navigationController?.navigationBar.tintColor = .black // change backButton and ... color
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func fetchAllPokemonTypes() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.allPokemonTypes = APIManager.shared.allPokemonTypes
            self.favoritesView.pokemonTypesCollectionView.reloadData()
        }
    }

    private func fetchFavoritePokemons() {
        FirebaseManager.shared.fetchFavoritePokemons { pokemons in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.pokemonsData = pokemons
                self.filteredPokemonsData = pokemons
                self.favoritesView.pokemonsCollectionView.reloadData()
            }
        }
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDataSource
extension FavoritesVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if favoritesView.pokemonTypesCollectionView == collectionView {
            return allPokemonTypes.count
        } else {
            return filteredPokemonsData.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if favoritesView.pokemonTypesCollectionView == collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonsAllTypesCell.id, for: indexPath) as? PokemonsAllTypesCell else { fatalError("Unsupported cell") }
            cell.contentView.alpha = selectedCells[indexPath] ?? 0.5
            cell.configure(with: allPokemonTypes[indexPath.row])

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonsCell.id, for: indexPath) as? PokemonsCell else { fatalError("Unsupported cell") }
            cell.configure(with: filteredPokemonsData[indexPath.row])

            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if favoritesView.pokemonTypesCollectionView == collectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) else {
                return
            }
            if let alphaValue = selectedCells[indexPath], alphaValue == 1.0 {
                cell.contentView.alpha = 0.5
                selectedCells.removeValue(forKey: indexPath)
                
                // Восстанавливаем отображение всех покемонов
                self.filteredPokemonsData = pokemonsData
                DispatchQueue.main.async {
                    self.favoritesView.pokemonsCollectionView.reloadData()
                }
            } else {
                    for cell in collectionView.visibleCells {
                        cell.contentView.alpha = 0.5
                    }
            selectedCells = [:]
            selectedCells[indexPath] = 1.0
                    cell.contentView.alpha = 1.0
                    
                UIView.animate(withDuration: 0.7, delay: 0.0) { [weak self] in
                    guard let self else { return }
                    self.favoritesView.pokemonsCollectionView.alpha = 0.0
                }
                
                    // Фильтруем и обновляем отображение покемонов по выбранному типу
                    self.filteredPokemonsData = pokemonsData
                    self.filteredPokemonsData = self.filteredPokemonsData.filter { pokemon in
                        guard let types = pokemon.types else { return false }
                        for type in types {
                            if type.name == allPokemonTypes[indexPath.row] {
                                return true
                            }
                        }
                        return false
                    }

                DispatchQueue.main.async {
                    self.favoritesView.pokemonsCollectionView.reloadData()
                }
                //                    self.favoritesView.spinner.stopAnimating()
                
                UIView.animate(withDuration: 0.7, delay: 0.0) { [weak self] in
                    guard let self else { return }
                    self.favoritesView.pokemonsCollectionView.alpha = 1.0
                }
        }
                    
            } else {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.alpha = 0.5
                UIView.animate(withDuration: 0.2) {
                    cell.contentView.alpha = 1.0
                }
            }
                print("now: \(filteredPokemonsData[indexPath.row])")
            let viewController = DetailsVC(pokemon: filteredPokemonsData[indexPath.row])
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if self.favoritesView.pokemonTypesCollectionView == collectionView {
            let bounds = collectionView.bounds.width
            let width = (bounds) / 3.5
            return CGSize(
                width: width,
                height: width / 4.6
            )
        } else {
            let bounds = UIScreen.main.bounds
            let width = (bounds.width - 30) / 2
            return CGSize(
                width: width,
                height: width * 1.5
            )
        }
    }
}
