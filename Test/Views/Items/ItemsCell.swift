import UIKit
import SnapKit
import SDWebImage

final class ItemsCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "items"
    
    private var itemCategories: [String] = []
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let itemPicture: UIImageView = {
        let image = Resources.Images.Item.itemPictureNoImage
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .systemYellow
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    
    let itemCategoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ItemCategoryCell.self, forCellWithReuseIdentifier: ItemCategoryCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let shortInfoFrame: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        itemCategoriesCollectionView.dataSource = self
        itemCategoriesCollectionView.delegate = self
        
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
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.addSubviews(itemPicture, idLabel, shortInfoFrame, nameLabel,  itemCategoriesCollectionView)
    }
    
    // DEBUG:
    private func debug() {
        nameLabel.backgroundColor = .green
        idLabel.backgroundColor = .red
        itemCategoriesCollectionView.backgroundColor = .blue
    }
    
    func configure(with item: EnhancedItem) {
        let categoryName = item.name ?? "???"
        nameLabel.text = TypeFormatter.shared.format(type: .name(string: categoryName))
        
        if let itemID = item.id {
            idLabel.text = "\(itemID)"
            if let pictureUrlString = item.pictureUrlString {
                itemPicture.sd_setImage(with: URL(string: pictureUrlString)) { [weak self] _, _, _, _ in
                    guard let self else { return }
                    self.itemPicture.contentMode = .scaleAspectFit
                }
            }
        } else {
            idLabel.text = "???"
        }
        if let categoryName = item.category {
            DispatchQueue.main.async {
                self.itemCategories.append(categoryName)
                self.itemCategoriesCollectionView.reloadData()
            }
        }
        itemCategories.removeAll()
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        itemPicture.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).multipliedBy(0.75)
        }
        idLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalTo(self.snp.bottom).multipliedBy(0.875)
        }
        shortInfoFrame.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.snp.bottom).multipliedBy(0.78)
        }
        itemCategoriesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.snp.bottom).multipliedBy(0.86)
        }
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDataSource
extension ItemsCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        itemCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCategoryCell.id, for: indexPath) as? ItemCategoryCell else { fatalError("Unsupported cell") }
        cell.configure(with: itemCategories[indexPath.row])
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension ItemsCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds = collectionView.bounds.width
        let width = (bounds) - 10
        return CGSize(
            width: width,
            height: width / 6.35
        )
    }
}
