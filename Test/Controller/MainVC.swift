import UIKit

final class MainVC: UIViewController {
    
    // MARK: - Properties
    var mainView: MainView { return self.view as! MainView }
    
    private var pokemonsData: [Pokemon] = []

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.pokemonsCollectionView.dataSource = self
        mainView.pokemonsCollectionView.delegate = self
        
        let randomStartIndex = Int.random(in: 1...50)
        getPokemons(in: randomStartIndex...randomStartIndex + 20)
    }
    
    override func loadView() {
        self.view = MainView(frame: UIScreen.main.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationControllerAppearance()
    }
    
    private func setUpNavigationControllerAppearance() {
        title = "Pokemons"
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
    
    private func getPokemons(in pokemonsIDRange: ClosedRange<Int>) {
        APIManager.shared.getPokemon(in: pokemonsIDRange) { [weak self] pokemon in
            DispatchQueue.main.async {
                guard let self else { return }
                self.pokemonsData.append(pokemon)
                self.mainView.pokemonsCollectionView.reloadData()
            }
        }
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDataSource
extension MainVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        pokemonsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.id, for: indexPath) as? MainCell else { fatalError("Unsupported cell") }
        cell.configure(with: pokemonsData[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MainVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewController = DetailsVC(pokemon: pokemonsData[indexPath.row])
        viewController.title = pokemonsData[indexPath.row].name?.uppercased()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension MainVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(
            width: width,
            height: width * 1.5
        )
    }
}
