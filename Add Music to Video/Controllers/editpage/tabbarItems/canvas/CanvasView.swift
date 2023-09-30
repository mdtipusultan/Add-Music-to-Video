//
//  CanvasView.swift
//  Add Music to Video
//
//  Created by Tipu on 30/9/23.
//

import UIKit

class CanvasView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
    

    @IBOutlet weak var CollectionView: UICollectionView!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           setupCollectionView()
       }
    
    private func setupCollectionView() {
         
          CollectionView.dataSource = self
          CollectionView.delegate = self

      }
    
    //MARK: COLLECTIOONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! canvasCollectionViewCell
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the cell size based on the screen size
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = screenSize.width/5 // You can adjust this as needed
        let cellHeight = screenSize.height * 0.1 // Adjust the multiplier to control the cell height
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
