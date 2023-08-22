import UIKit

class CroppingRatioCollectionViewCell: UICollectionViewCell {
    let ratioImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(ratioImageView)
        
        NSLayoutConstraint.activate([
            ratioImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            ratioImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratioImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratioImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

