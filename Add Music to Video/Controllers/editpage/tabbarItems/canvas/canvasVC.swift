//
//  canvasVC.swift
//  Add Music to Video
//
//  Created by Tipu on 2/10/23.
//

import UIKit

struct CropOption {
    let name: String
    let image: UIImage
    let size: CGSize // Add a size property for each option
}
protocol CanvasVCDelegate: AnyObject {
    func didSelectCropOption(_ cropOption: CropOption)
}

class canvasVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    weak var delegate: CanvasVCDelegate?
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    let cropOptions: [CropOption] = [
        CropOption(name: "9:16", image: UIImage(named: "cropped-tik-tok")!, size: CGSize(width: 100, height: 200)), // Adjust the size as needed
        CropOption(name: "1:1", image: UIImage(named: "instagram_icon")!, size: CGSize(width: 150, height: 150)), // Adjust the size as needed
        CropOption(name: "16:9", image: UIImage(named: "youtube_icon")!, size: CGSize(width: 160, height: 90)), // Adjust the size as needed
        CropOption(name: "16:9", image: UIImage(named: "twitter_icon")!, size: CGSize(width: 160, height: 90)), // Adjust the size as needed
        CropOption(name: "2:3", image: UIImage(named: "pinterest_icon")!, size: CGSize(width: 100, height: 150)), // Adjust the size as needed
        CropOption(name: "9:16", image: UIImage(named: "cropped-tik-tok")!, size: CGSize(width: 100, height: 200)), // Adjust the size as needed
        CropOption(name: "1:1", image: UIImage(named: "instagram_icon")!, size: CGSize(width: 150, height: 150)), // Adjust the size as needed
        CropOption(name: "16:9", image: UIImage(named: "youtube_icon")!, size: CGSize(width: 160, height: 90)), // Adjust the size as needed
        CropOption(name: "16:9", image: UIImage(named: "twitter_icon")!, size: CGSize(width: 160, height: 90)), // Adjust the size as needed
        CropOption(name: "2:3", image: UIImage(named: "pinterest_icon")!, size: CGSize(width: 100, height: 150)), // Adjust the size as needed
    ]

    // Define a variable to store the selected crop option index
       var selectedCropOptionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CollectionView.dataSource = self
        CollectionView.delegate = self
    }
    //MARK: COLLECTION-VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cropOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! canvasCollectionViewCell
        
        // Configure the cell with the crop option data
         let option = cropOptions[indexPath.item]
         cell.cropImages.image = option.image
         cell.cropImagesSize.text = option.name
               
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           // Retrieve the size from the cropOptions array
           return cropOptions[indexPath.item].size
       }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // Retrieve the selected crop option
        let selectedOption = cropOptions[indexPath.item]
print(selectedOption)
        // Ensure that delegate is not nil before calling the method
        if let delegate = delegate {
            delegate.didSelectCropOption(selectedOption)
            print("Delegate method called")
        } else {
            print("Delegate is nil")
        }
    }

}
