import UIKit

final class PokemonsVC: UIViewController {
    
    // MARK: - Properties
    private var pokemonsView: PokemonsView { return self.view as! PokemonsView }
    private var pokemonsViewModel: PokemonsViewModel
    
    private var selectedCells: [IndexPath: CGFloat] = [:]
    
    // MARK: - Life Cycle
    init(pokemonsViewModel: PokemonsViewModel) {
        self.pokemonsViewModel = pokemonsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = PokemonsView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchButton()
        fetchAllPokemonInfo()
        
        pokemonsViewModel.delegate = self
        pokemonsView.pokemonsCollectionView.dataSource = self
        pokemonsView.pokemonsCollectionView.delegate = self
        pokemonsView.pokemonTypesCollectionView.dataSource = self
        pokemonsView.pokemonTypesCollectionView.delegate = self
        
        getNextPagePokemonsList(isFirstPage: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationControllerAppearance()
    }
    
    // MARK: - Methods
    private func setupNavigationControllerAppearance() {
        title = "Pokemons"
        navigationItem.backButtonTitle = ""
        navigationItem.hidesBackButton = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemYellow // change navBar background color
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] // change navBar appearance settings
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.tintColor = .black // change backButton and ... color
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func addSearchButton() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc private func searchButtonTapped() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Введите имя или id покемона"
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = UIColor.systemGray
        searchController.searchBar.alpha = 0.7

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            searchController.searchBar.becomeFirstResponder()
        }
    }
    
    private func getNextPagePokemonsList(isFirstPage: Bool = false) {
        pokemonsViewModel.getNextPagePokemonsList(isFirstPage: isFirstPage)
    }
    
    private func fetchAllPokemonInfo() {
        fetchAllPokemonNames()
        fetchAllPokemonIDs()
        fetchAllPokemonTypes()
    }
    
    private func fetchAllPokemonNames() {
        pokemonsViewModel.fetchAllPokemonNames()
    }
    
    private func fetchAllPokemonIDs() {
        pokemonsViewModel.fetchAllPokemonIDs()
    }
    
    private func fetchAllPokemonTypes() {
        pokemonsViewModel.fetchAllPokemonTypes()
    }
    
    private func searchPokemons(byKeywordOrId keywordOrId: String) {
        pokemonsViewModel.searchPokemons(byKeywordOrId: keywordOrId)
    }
}

// MARK: - Extensions
// MARK: - PokemonsViewModelDelegate
extension PokemonsVC: PokemonsViewModelDelegate {
    func didUpdatePokemonsList() {
        DispatchQueue.main.async {
            self.pokemonsView.pokemonsCollectionView.reloadData()
        }
    }
    
    func didUpdatePokemonTypes() {
        DispatchQueue.main.async {
            self.pokemonsView.pokemonTypesCollectionView.reloadData()
        }
    }
    
    func didStartLoadingPokemons() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.pokemonsView.spinner.startAnimating()
        }
    }
    
    func didEndLoadingPokemons() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.pokemonsView.spinner.stopAnimating()
        }
    }
    
    func clearSelectedCells() {
        self.selectedCells = [:]
    }
}
// MARK: - UICollectionViewDataSource
extension PokemonsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if pokemonsView.pokemonTypesCollectionView == collectionView {
            return pokemonsViewModel.allPokemonTypes.count
        } else {
            return pokemonsViewModel.filteredPokemons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if pokemonsView.pokemonTypesCollectionView == collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonsAllTypesCell.id, for: indexPath) as? PokemonsAllTypesCell else { fatalError("Unsupported cell") }
            cell.contentView.alpha = selectedCells[indexPath] ?? 0.5
            cell.configure(with: pokemonsViewModel.allPokemonTypes[indexPath.row])

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonsCell.id, for: indexPath) as? PokemonsCell else { fatalError("Unsupported cell") }
            cell.configure(with: pokemonsViewModel.filteredPokemons[indexPath.row])
            
            return cell
        }
    }
}
// MARK: - UICollectionViewDelegate
extension PokemonsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if pokemonsView.pokemonTypesCollectionView == collectionView {
            guard !pokemonsViewModel.isPokemonTypesRequestInProgress else { return }
            
            for cell in collectionView.visibleCells {
                cell.contentView.alpha = 0.5
            }
            self.selectedCells = [:]
            self.selectedCells[indexPath] = 1.0
            
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.alpha = 1.0
                
                pokemonsView.spinner.startAnimating()
                pokemonsViewModel.isPokemonTypesRequestInProgress = true
                
                UIView.animate(withDuration: 0.7, delay: 0.0) { [weak self] in
                    guard let self else { return }
                    self.pokemonsView.pokemonsCollectionView.alpha = 0.0
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    APIManager.shared.getPokemons(byPokemonType: self.pokemonsViewModel.allPokemonTypes[indexPath.row].lowercased()) { [weak self] result in
                        guard let self else { return }
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let enhancedPokemons):
                                print("NEW DATA: \(enhancedPokemons)")
                                self.pokemonsViewModel.filteredPokemons = enhancedPokemons
                                self.pokemonsView.pokemonsCollectionView.reloadData()
                                self.pokemonsViewModel.isPokemonTypesRequestInProgress = false
                                self.pokemonsView.spinner.stopAnimating()
                                
                                UIView.animate(withDuration: 0.7, delay: 0.0) { [weak self] in
                                    guard let self else { return }
                                    self.pokemonsView.pokemonsCollectionView.alpha = 1.0
                                }
                            case .failure(_):
                                print("NO DATA")
                            }
                        }
                    }
                }
            }
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.alpha = 0.5
                UIView.animate(withDuration: 0.2) {
                    cell.contentView.alpha = 1.0
                }
            }
            let viewController = DetailsVC(pokemon: pokemonsViewModel.filteredPokemons[indexPath.row])
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension PokemonsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if pokemonsView.pokemonTypesCollectionView == collectionView {
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
// MARK: - UISearchControllerDelegate
extension PokemonsVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
        searchBar.text = nil
        pokemonsViewModel.filteredPokemons = pokemonsViewModel.pokemons
        pokemonsView.pokemonsCollectionView.reloadData()
        selectedCells = [:]
        pokemonsView.pokemonTypesCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            pokemonsViewModel.filteredPokemons = pokemonsViewModel.pokemons
            pokemonsView.pokemonsCollectionView.reloadData()
            selectedCells = [:]
            pokemonsView.pokemonTypesCollectionView.reloadData()
        } else {
            searchPokemons(byKeywordOrId: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            pokemonsViewModel.filteredPokemons = pokemonsViewModel.pokemons
            pokemonsView.pokemonsCollectionView.reloadData()
            selectedCells = [:]
            pokemonsView.pokemonTypesCollectionView.reloadData()
        }
    }
}
// MARK: - UIScrollViewDelegate
extension PokemonsVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - screenHeight {
            getNextPagePokemonsList()
        }
    }
}
