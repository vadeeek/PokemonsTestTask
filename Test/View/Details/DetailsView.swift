import UIKit
import SnapKit

final class DetailsView: UIView {

    // MARK: UIImageView
    let pokemonPicture: UIImageView = {
        let image = UIImage(named: "noImage")
        let imageView = UIImageView(image: image)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let doubleArrow: UIImageView = {
        let image = UIImage(named: "doubleArrow")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: UILabel
    let idLabel: UILabel = {
        let label = UILabel()
        label.text = "ID: "
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: UICollectionView
    let detailsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.id)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()

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
        addSubview(pokemonPicture)
        addSubview(doubleArrow)
        addSubview(heightLabel)
        addSubview(idLabel)
        addSubview(detailsCollectionView)
    }
    
    private func makeConstraints() {
        pokemonPicture.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(285)
        }
        
        doubleArrow.snp.makeConstraints { make in
            make.top.bottom.equalTo(pokemonPicture)
            make.centerX.equalTo(pokemonPicture.snp.trailing).offset(8)
        }
        
        idLabel.snp.makeConstraints { make in
            make.bottom.equalTo(pokemonPicture).offset(-5)
            make.leading.equalTo(pokemonPicture).offset(10)
        }
        
        heightLabel.snp.makeConstraints { make in
            make.leading.equalTo(doubleArrow.snp.centerX).offset(10)
            make.centerY.equalTo(doubleArrow)
        }
        
        detailsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pokemonPicture.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(270)
        }
    }
}
