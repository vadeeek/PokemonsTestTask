import UIKit




final class PokemonsVC: UIViewController {
    
    // MARK: - Properties
    private var pokemonsView: PokemonsView { return self.view as! PokemonsView }
    
    private var pokemonsData: [EnhancedPokemon] = []
    private var filteredPokemonsData: [EnhancedPokemon] = []
    private var allPokemonTypes: [String] = []
    private var selectedCells: [IndexPath: CGFloat] = [:]
    
    private var isPokemonsLoading = false
    private var isPokemonTypesRequestInProgress = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchButton()
        
        APIManager.shared.fetchAllPokemonNames()
        APIManager.shared.fetchAllPokemonIDs()
        fetchAllPokemonTypes()
        
        pokemonsView.pokemonsCollectionView.dataSource = self
        pokemonsView.pokemonsCollectionView.delegate = self
        pokemonsView.pokemonTypesCollectionView.dataSource = self
        pokemonsView.pokemonTypesCollectionView.delegate = self
        
//        var randomPokemonsIDsList: Set<Int> = []
//        while randomPokemonsIDsList.count != 20 {
//            let randomPokemonID = Int.random(in: 1...1302)
//            randomPokemonsIDsList.insert(randomPokemonID)
//        }
        getNextPagePokemonsList(isFirstPage: true)
    }
    
    override func loadView() {
        self.view = PokemonsView(frame: UIScreen.main.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationControllerAppearance()
    }
    
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
    
//    private func getPokemons(from pokemonsIDsArray: Set<Int>) {
    private func getNextPagePokemonsList(isFirstPage: Bool = false) {
        guard !isPokemonsLoading else { return }
        pokemonsView.spinner.startAnimating()
        
        isPokemonsLoading = true

        APIManager.shared.getNextPagePokemonsList(isFirstPage: isFirstPage) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let enhancedPokemonsArray):
                self.handleSuccessfulResponse(enhancedPokemonsArray)
                self.pokemonsView.spinner.stopAnimating()
            case .failure(let error):
                self.handleFailedResponse(error)
            }
        }
    }
    
    private func handleSuccessfulResponse(_ enhancedPokemonsArray: [EnhancedPokemon]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.pokemonsData += enhancedPokemonsArray
            self.filteredPokemonsData += enhancedPokemonsArray
            self.pokemonsView.pokemonsCollectionView.reloadData()
            self.isPokemonsLoading = false
        }
    }

    private func handleFailedResponse(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            print("Error: \(error)")
            self.isPokemonsLoading = false
        }
    }
    
    private func fetchAllPokemonTypes() {
        APIManager.shared.fetchAllPokemonTypes { [weak self] result in
            switch result {
            case .success(let allPokemonTypes):
                DispatchQueue.main.async {
                    guard let self else { return }
                    self.allPokemonTypes = allPokemonTypes
                    self.pokemonsView.pokemonTypesCollectionView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    private func searchPokemons(byKeywordOrId keywordOrId: String) {
        APIManager.shared.searchPokemons(byKeywordOrId: keywordOrId) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let enhancedPokemonsArray):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    self.filteredPokemonsData = enhancedPokemonsArray
                    self.pokemonsView.pokemonsCollectionView.reloadData()
                    self.selectedCells = [:]
                    self.pokemonsView.pokemonTypesCollectionView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error: \(error)")
                }
            }
        }
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDataSource
extension PokemonsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if pokemonsView.pokemonTypesCollectionView == collectionView {
            return allPokemonTypes.count
        } else {
            return filteredPokemonsData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if pokemonsView.pokemonTypesCollectionView == collectionView {
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
extension PokemonsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if pokemonsView.pokemonTypesCollectionView == collectionView {
            guard !isPokemonTypesRequestInProgress else { return }
            
            for cell in collectionView.visibleCells {
                cell.contentView.alpha = 0.5
            }
            selectedCells = [:]
            selectedCells[indexPath] = 1.0
            
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.alpha = 1.0
                
                pokemonsView.spinner.startAnimating()
                isPokemonTypesRequestInProgress = true
                
                UIView.animate(withDuration: 0.7, delay: 0.0) { [weak self] in
                    guard let self else { return }
                    self.pokemonsView.pokemonsCollectionView.alpha = 0.0
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    APIManager.shared.getPokemons(byPokemonType: self.allPokemonTypes[indexPath.row].lowercased()) { enhancedPokemons in
                        DispatchQueue.main.async { [weak self] in
                            guard let self else { return }
                            print("NEW DATA: \(enhancedPokemons)")
                            self.filteredPokemonsData = enhancedPokemons
                            self.pokemonsView.pokemonsCollectionView.reloadData()
                            self.isPokemonTypesRequestInProgress = false
                            self.pokemonsView.spinner.stopAnimating()
                            
                            UIView.animate(withDuration: 0.7, delay: 0.0) { [weak self] in
                                guard let self else { return }
                                self.pokemonsView.pokemonsCollectionView.alpha = 1.0
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
            let viewController = DetailsVC(pokemon: filteredPokemonsData[indexPath.row])
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
        filteredPokemonsData = pokemonsData
        pokemonsView.pokemonsCollectionView.reloadData()
        selectedCells = [:]
        pokemonsView.pokemonTypesCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            filteredPokemonsData = pokemonsData
            pokemonsView.pokemonsCollectionView.reloadData()
            selectedCells = [:]
            pokemonsView.pokemonTypesCollectionView.reloadData()
        } else {
            searchPokemons(byKeywordOrId: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredPokemonsData = pokemonsData
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
