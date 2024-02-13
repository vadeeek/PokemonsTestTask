import UIKit
import SnapKit

final class LaunchView: UIView {
    
    // MARK: - Properties
    
    // MARK: UIImageView
    private lazy var pokemonLabelPicture: UIImageView = {
        let image = UIImage(named: "pokemonLabel")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.0
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    private lazy var pokeballImage: UIImageView = {
        let image = UIImage(named: "pokeball")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.0
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeConstraints()
        startAnimations()
        showElementsWithAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .systemYellow
        addSubview(pokemonLabelPicture)
        addSubview(pokeballImage)
    }
    
    private func startAnimations() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            self.pokemonLabelPicture.alpha = 1.0
            self.pokemonLabelPicture.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = 1.0
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotationAnimation.repeatCount = .greatestFiniteMagnitude
        pokeballImage.layer.add(rotationAnimation, forKey: "rotate")
    }
    
    private func showElementsWithAnimation() {
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
            self.pokemonLabelPicture.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.pokeballImage.alpha = 1.0
        }, completion: nil)
    }

// MARK: - Constraints
    private func makeConstraints() {
        pokemonLabelPicture.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(40)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-40)
            make.centerY.equalToSuperview().offset(-110)
        }
        
        pokeballImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pokemonLabelPicture.snp.bottom).offset(-15)
            make.height.equalTo(120)
        }
    }
}
