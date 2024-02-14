import UIKit

final class DetailsVC: UIViewController {

    // MARK: - Properties
    var detailsView: DetailsView { return self.view as! DetailsView }
    
    private var pokemon: Pokemon
    
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
        
        detailsView.detailsCollectionView.dataSource = self
        detailsView.detailsCollectionView.delegate = self
        
        configureData()
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
    
    private func configureData() {
        detailsView.configureData(with: pokemon)
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDataSource
extension DetailsVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let count = pokemon.stats?.count {
            return count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCell.id, for: indexPath) as? DetailsCell else { fatalError("Unsupported cell") }
        
        guard let stat = pokemon.stats?[indexPath.row].baseStat else { return cell }
        cell.configureData(statTitle: statsTitles[indexPath.row], value: stat)
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension DetailsVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: detailsView.detailsCollectionView.frame.width - 20, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
