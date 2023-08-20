import UIKit

class CroppingRatioCollectionViewCell: UICollectionViewCell {
    let ratioLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubview(ratioLabel)
        
        NSLayoutConstraint.activate([
            ratioLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ratioLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
