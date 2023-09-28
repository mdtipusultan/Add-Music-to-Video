//
//  CanvasVC.swift
//  Add Music to Video
//
//  Created by Tipu on 19/8/23.
//

import UIKit
import AVFoundation

class CanvasVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    @IBOutlet weak var coollectionview: UICollectionView!
    
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
    }
    
    //MARK: COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return croppingRatios.count
    }
   
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = coollectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CroppingRatioCollectionViewCell
            
            let ratio = croppingRatios[indexPath.item]
            cell.ratioImageView.image = generateRatioImage(for: ratio, size: cell.contentView.frame.size)
            
            return cell
        }
        
        private func generateRatioImage(for ratio: CGSize, size: CGSize) -> UIImage? {
            let aspectRatio = ratio.width / ratio.height
            
            let renderer = UIGraphicsImageRenderer(size: size)
            let image = renderer.image { context in
                let canvasSize: CGSize
                if aspectRatio >= 1 {
                    canvasSize = CGSize(width: size.width, height: size.width / aspectRatio)
                } else {
                    canvasSize = CGSize(width: size.height * aspectRatio, height: size.height)
                }
                
                let canvasRect = CGRect(
                    origin: CGPoint(
                        x: (size.width - canvasSize.width) / 2,
                        y: (size.height - canvasSize.height) / 2
                    ),
                    size: canvasSize
                )
                
                UIColor.lightGray.setFill()
                context.fill(CGRect(origin: .zero, size: size))
                
                let text = "\(Int(ratio.width)):\(Int(ratio.height))"
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: UIColor.black
                ]
                let textSize = text.size(withAttributes: attributes)
                let textOrigin = CGPoint(
                    x: (canvasSize.width - textSize.width) / 2 + canvasRect.minX,
                    y: (canvasSize.height - textSize.height) / 2 + canvasRect.minY
                )
                text.draw(at: textOrigin, withAttributes: attributes)
            }
            
            return image
        }
}
