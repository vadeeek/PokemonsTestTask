import UIKit
import SnapKit

final class FavoritesView: UIView {
    
    // MARK: - Properties
    
    // MARK: UICollectionView
    let pokemonTypesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonsAllTypesCell.self, forCellWithReuseIdentifier: PokemonsAllTypesCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    let pokemonsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonsCell.self, forCellWithReuseIdentifier: PokemonsCell.id)
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeConstraints()
        // DEBUG:
        debug()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black
        addSubviews(pokemonsCollectionView, pokemonTypesCollectionView)
    }
    // DEBUG:
    private func debug() {
        pokemonsCollectionView.backgroundColor = .green
        pokemonTypesCollectionView.backgroundColor = .purple
    }
    
//    // MARK: - Constraints
    private func makeConstraints() {
        pokemonTypesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(self.snp.width).multipliedBy(0.1)
        }
        pokemonsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(pokemonTypesCollectionView.snp.bottom).offset(5)
            make.bottom.equalTo(self)
        }
    }
}
