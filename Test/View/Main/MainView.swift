import UIKit
import SnapKit

final class MainView: UIView {
    
    // MARK: - Properties
    
    // MARK: UICollectionView
    lazy var pokemonsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.id)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    // MARK: UIImageView
//    private lazy var pokemonPicture: UIImageView = {
//        let image = UIImage(named: "pokemon")
//        let imageView = UIImageView(image: image)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//
//        return imageView
//    }()

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
        backgroundColor = .black
        addSubviews(pokemonsCollectionView)
//        addSubviews(pokemonsCollectionView, pokemonPicture)
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        pokemonsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(5)
            make.bottom.equalTo(self)
        }
        
//        pokemonPicture.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().offset(-30)
//            make.top.equalTo(self.safeAreaLayoutGuide).offset(5)
//            make.height.equalTo(150)
//            make.width.equalTo(139)
//        }
    }
}
