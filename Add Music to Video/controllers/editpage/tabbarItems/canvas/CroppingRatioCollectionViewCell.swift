import UIKit

protocol CroppingRatioCellDelegate: AnyObject {
    func croppingRatioCell(_ cell: CroppingRatioCollectionViewCell, didSelectRatio ratio: CGSize)
}

class CroppingRatioCollectionViewCell: UICollectionViewCell {
    let ratioLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: CroppingRatioCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupUI() {
        contentView.addSubview(ratioLabel)
        
        NSLayoutConstraint.activate([
            ratioLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ratioLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc func cellTapped() {
        if let text = ratioLabel.text,
           let ratio = CGSize(string: text) {
            delegate?.croppingRatioCell(self, didSelectRatio: ratio)
        }
    }
}

extension CGSize {
    init?(string: String) {
        let components = string.split(separator: ":")
        guard components.count == 2,
              let width = Double(components[0]),
              let height = Double(components[1]) else {
            return nil
        }
        self.init(width: width, height: height)
    }
}
