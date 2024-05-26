import UIKit
import SnapKit

final class ItemsView: UIView {
    
    // MARK: - Properties
    let itemCategoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ItemsAllCategoriesCell.self, forCellWithReuseIdentifier: ItemsAllCategoriesCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear // FIXME: возможно не нужно это указывать
        return collectionView
    }()
    
    let itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ItemsCell.self, forCellWithReuseIdentifier: ItemsCell.id)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeConstraints()
        // DEBUG:
//        debug()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupUI() {
        backgroundColor = .black
        addSubviews(spinner, itemsCollectionView, itemCategoriesCollectionView)
    }
    // DEBUG:
    private func debug() {
        itemsCollectionView.backgroundColor = .green
        itemCategoriesCollectionView.backgroundColor = .purple
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        itemCategoriesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(self.snp.width).multipliedBy(0.1)
        }
        itemsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(itemCategoriesCollectionView.snp.bottom).offset(5)
            make.bottom.equalTo(self)
        }
        spinner.snp.makeConstraints { make in
            make.center.equalTo(itemsCollectionView)
        }
    }
}
