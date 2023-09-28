//
//  CustomCollectionViewCell.swift
//  Add Music to Video
//
//  Created by Tipu on 28/9/23.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        textLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

