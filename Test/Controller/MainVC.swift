import UIKit

final class MainVC: UIViewController {
    
    var mainView: MainView { return self.view as! MainView }
    
    private var pokemonsData: [Pokemon] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "POKEMONS"
        navigationItem.backButtonTitle = ""
        
        mainView.pokemonCollectionView.dataSource = self
        mainView.pokemonCollectionView.delegate = self
        
        getPokemons()
    }
    
    override func loadView() {
        self.view = MainView(frame: UIScreen.main.bounds)
    }
    
    private func getPokemons() {
        APIManager.shared.getPokemon { [weak self] pokemon in
            DispatchQueue.main.async {
                guard let self else { return }
                self.pokemonsData.append(pokemon)
                self.mainView.pokemonCollectionView.reloadData()
            }
        }
    }
}

// MARK: - Extensions
extension MainVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        pokemonsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.id, for: indexPath) as? MainCell
        else {
            fatalError("UnSupported")
        }
        cell.nameLabel.text = pokemonsData[indexPath.row].name?.capitalized
        return cell
    }
}

extension MainVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewController = DetailsVC(pokemon: pokemonsData[indexPath.row])
        viewController.title = pokemonsData[indexPath.row].name?.uppercased()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainView.pokemonCollectionView.frame.width - 20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
