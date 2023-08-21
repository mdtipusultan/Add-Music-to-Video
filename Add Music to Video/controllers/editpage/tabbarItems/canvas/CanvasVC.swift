//
//  CanvasVC.swift
//  Add Music to Video
//
//  Created by Tipu on 19/8/23.
//

import UIKit
import AVFoundation

class CanvasVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,CroppingRatioCellDelegate {
   

    @IBOutlet weak var coollectionview: UICollectionView!
    var selectedVideoURL: URL? // Add this property

    var selectedCroppingRatio: CGSize?
    
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
    
        // Play the video using AVPlayer with the selected cropping ratio
              if let selectedVideoURL = selectedVideoURL {
                  let player = AVPlayer(url: selectedVideoURL)
                  let playerLayer = AVPlayerLayer(player: player)
                  playerLayer.videoGravity = .resize // Apply the selected cropping ratio
                  playerLayer.frame = view.bounds
                  view.layer.addSublayer(playerLayer)
                  player.play()
              }
    }
    func croppingRatioCell(_ cell: CroppingRatioCollectionViewCell, didSelectRatio ratio: CGSize) {
         selectedCroppingRatio = ratio
         coollectionview.reloadData()
         
         // Apply the selected cropping ratio to the video player if it's playing
         let playerLayer = view.layer.sublayers?.compactMap { $0 as? AVPlayerLayer }.first
         playerLayer?.videoGravity = .resizeAspectFill // Apply the selected cropping ratio
     }
    @IBAction func cancleButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
            // Apply the selected cropping ratio to the video
            let playerLayer = view.layer.sublayers?.compactMap { $0 as? AVPlayerLayer }.first
            playerLayer?.videoGravity = .resizeAspectFill // Apply the selected cropping ratio
            
            // Perform any other actions you want
        }

    //MARK: COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return croppingRatios.count
      }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = coollectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CroppingRatioCollectionViewCell
        
        let ratio = croppingRatios[indexPath.item]
        cell.ratioLabel.text = "\(Int(ratio.width)):\(Int(ratio.height))"
        
        // Set the selected state of the cell based on the selectedCroppingRatio
        cell.isSelected = ratio == selectedCroppingRatio
        
        return cell
    }


}
