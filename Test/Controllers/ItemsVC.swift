import UIKit

final class ItemsVC: UIViewController {
    
    // MARK: - Properties
    private var itemsView: ItemsView { return self.view as! ItemsView }
    
    private var itemsData: [EnhancedItem] = []
    private var filteredItemsData: [EnhancedItem] = []
    private var allItemCategories: [String] = []
    private var selectedCells: [IndexPath: CGFloat] = [:]
    
    private var isItemsLoading = false
    private var isItemCategoriesRequestInProgress = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchButton()
        
        APIManager.shared.fetchAllItemNames()
        APIManager.shared.fetchAllItemIDs()
        fetchAllItemCategories()
        
        itemsView.itemsCollectionView.dataSource = self
        itemsView.itemsCollectionView.delegate = self
        itemsView.itemCategoriesCollectionView.dataSource = self
        itemsView.itemCategoriesCollectionView.delegate = self
        
        getNextPageItemsList(isFirstPage: true)
    }
    
    override func loadView() {
        self.view = ItemsView(frame: UIScreen.main.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationControllerAppearance()
    }
    
    // MARK: - Methods
    private func setupNavigationControllerAppearance() {
        title = "Items"
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
        searchController.searchBar.placeholder = "Введите имя или id предмета"
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = UIColor.systemGray
        searchController.searchBar.alpha = 0.7
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            searchController.searchBar.becomeFirstResponder()
        }
    }
    
    private func getNextPageItemsList(isFirstPage: Bool = false) {
        guard !isItemsLoading else { return }
        itemsView.spinner.startAnimating()
        
        isItemsLoading = true

        APIManager.shared.getNextPageItemsList(isFirstPage: isFirstPage) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let enhancedItemsArray):
                self.handleSuccessfulResponse(enhancedItemsArray)
                self.itemsView.spinner.stopAnimating()
            case .failure(let error):
                self.handleFailedResponse(error)
            }
        }
    }
    
    private func handleSuccessfulResponse(_ enhancedItemsArray: [EnhancedItem]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.itemsData += enhancedItemsArray
            self.filteredItemsData += enhancedItemsArray
            self.itemsView.itemsCollectionView.reloadData()
            self.isItemsLoading = false
        }
    }

    private func handleFailedResponse(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            print("Error: \(error)")
            self.isItemsLoading = false
        }
    }
    
    private func fetchAllItemCategories() {
        APIManager.shared.fetchAllItemCategories { [weak self] result in
            switch result {
            case .success(let allItemCategories):
                DispatchQueue.main.async {
                    guard let self else { return }
                    self.allItemCategories = allItemCategories
                    TypeFormatter.shared.generateCategoryColors()
                    self.itemsView.itemCategoriesCollectionView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error: \(error)")
                }
            }
        }
    }

    private func searchItems(byKeywordOrId keywordOrId: String) {
        APIManager.shared.searchItems(byKeywordOrId: keywordOrId) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let enhancedItemsArray):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    self.filteredItemsData = enhancedItemsArray
                    self.itemsView.itemsCollectionView.reloadData()
                    self.selectedCells = [:]
                    self.itemsView.itemCategoriesCollectionView.reloadData()
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
extension ItemsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if itemsView.itemCategoriesCollectionView == collectionView {
            return allItemCategories.count
        } else {
            return filteredItemsData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if itemsView.itemCategoriesCollectionView == collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemsAllCategoriesCell.id, for: indexPath) as? ItemsAllCategoriesCell else { fatalError("Unsupported cell") }
            cell.contentView.alpha = selectedCells[indexPath] ?? 0.5
            cell.configure(with: allItemCategories[indexPath.row])

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemsCell.id, for: indexPath) as? ItemsCell else { fatalError("Unsupported cell") }
            cell.configure(with: filteredItemsData[indexPath.row])
            
            return cell
        }
    }
}
// MARK: - UICollectionViewDelegate
extension ItemsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if itemsView.itemCategoriesCollectionView == collectionView {
            guard !isItemCategoriesRequestInProgress else { return }
            
            for cell in collectionView.visibleCells {
                cell.contentView.alpha = 0.5
            }
            selectedCells = [:]
            selectedCells[indexPath] = 1.0
            
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.alpha = 1.0
                
                itemsView.spinner.startAnimating()
                isItemCategoriesRequestInProgress = true
                
                UIView.animate(withDuration: 0.7, delay: 0.0) { [weak self] in
                    guard let self else { return }
                    self.itemsView.itemsCollectionView.alpha = 0.0
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    APIManager.shared.getItems(byItemCategory: self.allItemCategories[indexPath.row].lowercased()) { [weak self] result in
                        guard let self else { return }
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let enhancedItems):
                                print("NEW DATA: \(enhancedItems)")
                                self.filteredItemsData = enhancedItems
                                self.itemsView.itemsCollectionView.reloadData()
                                self.isItemCategoriesRequestInProgress = false
                                self.itemsView.spinner.stopAnimating()
                                
                                UIView.animate(withDuration: 0.7, delay: 0.0) { [weak self] in
                                    guard let self else { return }
                                    self.itemsView.itemsCollectionView.alpha = 1.0
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
//            let viewController = DetailsVC(pokemon: filteredPokemonsData[indexPath.row])
//            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension ItemsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if itemsView.itemCategoriesCollectionView == collectionView {
            let bounds = collectionView.bounds.width
            let width = (bounds) / 2.5
            return CGSize(
                width: width,
                height: width / 6.35
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
extension ItemsVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
        searchBar.text = nil
        filteredItemsData = itemsData
        itemsView.itemsCollectionView.reloadData()
        selectedCells = [:]
        itemsView.itemCategoriesCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            filteredItemsData = itemsData
            itemsView.itemsCollectionView.reloadData()
            selectedCells = [:]
            itemsView.itemCategoriesCollectionView.reloadData()
        } else {
            searchItems(byKeywordOrId: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredItemsData = itemsData
            itemsView.itemsCollectionView.reloadData()
            selectedCells = [:]
            itemsView.itemCategoriesCollectionView.reloadData()
        }
    }
}
// MARK: - UIScrollViewDelegate
extension ItemsVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - screenHeight {
            getNextPageItemsList()
        }
    }
}
