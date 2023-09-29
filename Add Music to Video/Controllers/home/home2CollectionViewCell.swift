//
//  home2CollectionViewCell.swift
//  Add Music to Video
//
//  Created by Tipu on 19/8/23.
//

import UIKit

class home2CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var title1: UILabel!
  
    override func layoutSubviews() {
          super.layoutSubviews()
        print("ImageView Frame: \(imageView1.frame)")
        print("ImageView Constraints: \(imageView1.constraints)")
          let newImageViewSize = CGSize(width: 60, height: 60)
          imageView1.frame.size = newImageViewSize
        print("ImageView Frame: \(imageView1.frame)")
        print("ImageView Constraints: \(imageView1.constraints)")
      }
}
