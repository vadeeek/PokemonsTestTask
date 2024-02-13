import UIKit
import SnapKit

final class MainView: UIView {
    
    // MARK: - Properties
    
    // MARK: UICollectionView
    lazy var pokemonsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.id)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    // MARK: UIImageView
    private lazy var pokemonPicture: UIImageView = {
        let image = UIImage(named: "pokemon")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        addSubview(pokemonsCollectionView)
        addSubview(pokemonPicture)
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        pokemonsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(5)
            make.bottom.equalTo(self)
        }
        
        pokemonPicture.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(5)
            make.height.equalTo(150)
            make.width.equalTo(139)
        }
    }
}
