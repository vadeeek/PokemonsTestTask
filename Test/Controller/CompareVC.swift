import UIKit

final class CompareVC: UIViewController {
    
    // MARK: - Properties
    var selectedPokemons: [EnhancedPokemon] = []
    
    private var compareView: CompareView { return self.view as! CompareView }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addClearButton()
        
        compareView.selectedPokemonsCollectionView.dataSource = self
        compareView.selectedPokemonsCollectionView.delegate = self
    }
    
    override func loadView() {
        self.view = CompareView(frame: UIScreen.main.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationControllerAppearance()
        getSelectedPokemons()
    }
    
    private func addClearButton() {
        let rightButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(clearButtonTapped(_:)))
        rightButton.title = "Clear"
        rightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func clearButtonTapped(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.clearSelectedPokemons()
            self.compareView.selectedPokemonsCollectionView.reloadData()
        }
    }
    
    private func clearSelectedPokemons() {
        selectedPokemons = []
        ComparePokemonsManager.shared.clearSelectedPokemons()
    }
    
    private func setupNavigationControllerAppearance() {
        title = "Compare"
        navigationItem.backButtonTitle = ""
        navigationItem.hidesBackButton = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemYellow // change navBar background color
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] // change navBar appearance settings
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func getSelectedPokemons() {
        DispatchQueue.main.async {
            self.selectedPokemons = ComparePokemonsManager.shared.selectedPokemons
            self.compareView.selectedPokemonsCollectionView.reloadData()
        }
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDataSource
extension CompareVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        selectedPokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompareCell.id, for: indexPath) as? CompareCell else { fatalError("Unsupported cell") }
        if selectedPokemons.count > 0 {
            cell.configure(with: selectedPokemons[indexPath.row])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CompareVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(
            width: width,
            height: width * 6.0
        )
    }
}
