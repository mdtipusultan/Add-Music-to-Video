//
//  CanvasVC.swift
//  Add Music to Video
//
//  Created by Tipu on 19/8/23.
//

import UIKit

class CanvasVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var coollectionview: UICollectionView!
    
    let croppingRatios: [CGSize] = [
        CGSize(width: 1, height: 1),
        CGSize(width: 4, height: 5),
        CGSize(width: 3, height: 4),
        CGSize(width: 2, height: 3),
        CGSize(width: 1, height: 2),
        CGSize(width: 9, height: 16),
        CGSize(width: 3, height: 2),
        CGSize(width: 16, height: 9),
        CGSize(width: 5, height: 7),
        CGSize(width: 7, height: 5)
        // Add more cropping ratios as needed
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        coollectionview.delegate = self
                coollectionview.dataSource = self
    }
    
    @IBAction func cancleButtonTapped(_ sender: UIBarButtonItem) {
        
        //dismiss(animated: true, completion: nil)
       // _ = navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
     

    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        
    }
    //MARK: COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return croppingRatios.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = coollectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CroppingRatioCollectionViewCell
          
          let ratio = croppingRatios[indexPath.item]
          cell.ratioLabel.text = "\(Int(ratio.width)):\(Int(ratio.height))"
          
          return cell
      }
}
