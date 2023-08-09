//
//  HomeVC.swift
//  Add Music to Video
//
//  Created by Tipu on 9/8/23.
//

import UIKit

class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var BannerView: UIView!
    @IBOutlet weak var appReferView: UIView!
    
    @IBOutlet weak var collectionview: UICollectionView!
    let imageArray = ["figure.martial.arts", "slowmo", "video.slash", "music.note.house", "music.quarternote.3", "scissors.badge.ellipsis"]
        let titleArray = ["AL Effects", "Slow Motion", "Cut Video", "Cut Audio", "Merge Audio", "Extract Audio"]
    let tintColors: [UIColor] = [.red, .systemPink, .green, .yellow, .orange, .systemBlue]
    override func viewDidLoad() {
        super.viewDidLoad()
        BannerView.layer.cornerRadius = 10
        appReferView.layer.cornerRadius = 10
        
        collectionview.dataSource = self
        collectionview.delegate = self
        
        if let flowLayout = collectionview.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

    }
    
    //MARK: COLLECTIONVIEW
    func numberOfSections(in collectionView: UICollectionView) -> Int {
          return 2
      }
      
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return section == 0 ? 1 : 6
      }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! HomeCollectionViewCell
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .lightGray // Set your desired cell color
            // Configure the cell content for the first section
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! HomeCollectionViewCell
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .lightGray // Set your desired cell color
            cell.titleLabel.text = titleArray[indexPath.item]
              cell.imageView.image = UIImage(systemName: imageArray[indexPath.item] )
            // Configure the cell content for the second section
            // Set the tint color based on the index
                   cell.imageView.tintColor = tintColors[indexPath.item]
            
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionview.bounds.width, height: 80) // Adjust the width and height as needed
            
        } else {
            let spacing: CGFloat = 5
            let availableWidth = collectionView.bounds.width - spacing * 4 // Two 10pt spacings and two 50% widths
            let cellWidth = availableWidth / 2
            return CGSize(width: cellWidth, height: 50) // Using square cells for simplicity
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else{
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        }
        
    }
}
