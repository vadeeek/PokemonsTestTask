import UIKit

final class DetailsVC: UIViewController {

    var detailsView: DetailsView { return self.view as! DetailsView }
    
    var pokemon: Pokemon
    
    private let statsTitles = ["❤️ Health Points:", "⚔️ Attack:", "🛡️ Defense:", "✨ Special Attack:", "🔮 Special Defense:", "💨 Speed:"]
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsView.detailsCollectionView.dataSource = self
        detailsView.detailsCollectionView.delegate = self
        
        configureData()
    }
    
    override func loadView() {
        self.view = DetailsView(frame: UIScreen.main.bounds)
    }
    
    private func configureData() {
        if let id = pokemon.id, let height = pokemon.height {
            detailsView.idLabel.text = "ID: \(id)"
            detailsView.heightLabel.text = "\(height)"
        } else {
            detailsView.idLabel.text = "ID: ?"
        }
        
        if let urlPictureString = pokemon.sprites?.frontDefault {
            APIManager.shared.getPokemonPicture(urlString: urlPictureString) { [weak self] pokemonPictureData in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.detailsView.pokemonPicture.image = UIImage(data: pokemonPictureData)
                }
            }
        }
    }
}

// MARK: - Extensions
extension DetailsVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let count = pokemon.stats?.count {
            return count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCell.id, for: indexPath) as! DetailsCell
        
        guard let stat = pokemon.stats?[indexPath.row].baseStat else { return cell }
        cell.configureData(statTitle: statsTitles[indexPath.row], value: stat)
        return cell
    }
}

extension DetailsVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: detailsView.detailsCollectionView.frame.width - 20, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
