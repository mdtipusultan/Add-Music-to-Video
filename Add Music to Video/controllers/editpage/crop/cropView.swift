//
//  cropView.swift
//  Add Music to Video
//
//  Created by Tipu on 27/9/23.
//

import UIKit

class cropView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dummyData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"]

    // Initialize your collection view and set its delegate and data source.
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cellIdentifier")
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
       // collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

    }
}

extension cropView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return dummyData.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! CustomCollectionViewCell
           cell.textLabel.text = dummyData[indexPath.item]
           return cell
       }
}

extension cropView: UICollectionViewDelegate {
    // Implement delegate methods as needed
}
