import UIKit
import SnapKit

final class CompareView: UIView {

    // MARK: - Properties
    
    // MARK: UICollectionView
    let selectedPokemonsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CompareCell.self, forCellWithReuseIdentifier: CompareCell.id)
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
        backgroundColor = .systemGray
        addSubviews(selectedPokemonsCollectionView)
    }
    
    // DEBUG:
    private func debug() {
        selectedPokemonsCollectionView.backgroundColor = .red
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        selectedPokemonsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(5)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
