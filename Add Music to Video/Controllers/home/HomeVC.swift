//
//  HomeVC.swift
//  Add Music to Video
//
//  Created by Tipu on 9/8/23.
//

import UIKit
import GoogleMobileAds

class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GADBannerViewDelegate {
    
    @IBOutlet weak var BannerView: GADBannerView!
    @IBOutlet weak var appReferView: UIView! // Streaming Videos
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
        DispatchQueue.main.async {
            self.BannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"  // Replace with actual ad unit ID
            self.BannerView.rootViewController = self
            self.BannerView.delegate = self
            
            let adRequest = GADRequest()
            self.BannerView.load(adRequest)
        }
        
        // Streaming Videos
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(appReferViewTapped))
        appReferView.addGestureRecognizer(tapGesture)
        appReferView.isUserInteractionEnabled = true

    }
    // Streaming Videos
    @objc func appReferViewTapped() {
        // Instantiate the video streaming view controller
        let videoVC = storyboard?.instantiateViewController(withIdentifier: "VideoStreamingVC") as! VideoStreamingVC
        
        // Push to the video streaming view controller
        navigationController?.pushViewController(videoVC, animated: true)
    }

    
    @IBAction func settingButtonTapped(_ sender: UIBarButtonItem) {
        // Create an instance of SettingsVC
        let settingsVC = storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        
        // Wrap the settingsVC in a UINavigationController
        let navigationController = UINavigationController(rootViewController: settingsVC)
        
        // Present the navigationController with a flip animation
        navigationController.modalTransitionStyle = .flipHorizontal
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func purchaseButtonTapped(_ sender: UIBarButtonItem) {
        
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! home2CollectionViewCell
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .lightGray // Set your desired cell color
            // Configure the cell content for the first section
            cell.title1.text = "Add Music to Video"
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Section 0 cell was tapped
            print("Section 0 cell tapped")
            // Present the photo picker when the Section 0 cell is tapped
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.mediaTypes = ["public.movie"]
            present(picker, animated: true, completion: nil)
        } else {
            // Section 1 cells were tapped
            
            // Get the selected cell's title and image name
            let cellTitle = titleArray[indexPath.item]
            let imageName = imageArray[indexPath.item]
            
            // Perform different actions based on the tapped cell
            switch imageName {
            case "figure.martial.arts":
                handleMartialArtsCellTap()
                
            case "slowmo":
                handleSlowMotionCellTap()
                
            case "video.slash":
                handleVideoSlashCellTap()
                
            case "music.note.house":
                handleMusicNoteHouseCellTap()
                
            case "music.quarternote.3":
                handleMusicQuarterNoteCellTap()
                
            case "scissors.badge.ellipsis":
                handleScissorsCellTap()
                
            default:
                handleOtherCellTap(cellTitle: cellTitle)
            }
        }
    }
    
    func handleMartialArtsCellTap() {
        print("Martial Arts cell tapped")
        // Perform action for martial arts cell
    }
    
    func handleSlowMotionCellTap() {
        print("Slow Motion cell tapped")
        // Perform action for slow motion cell
    }
    
    func handleVideoSlashCellTap() {
        print("Video Slash cell tapped")
        // Perform action for video slash cell
    }
    
    func handleMusicNoteHouseCellTap() {
        print("Music Note House cell tapped")
        // Perform action for music note house cell
    }
    
    func handleMusicQuarterNoteCellTap() {
        print("Music Quarter Note cell tapped")
        // Perform action for music quarter note cell
    }
    
    func handleScissorsCellTap() {
        print("Scissors cell tapped")
        // Perform action for scissors cell
    }
    
    func handleOtherCellTap(cellTitle: String) {
        print("Cell tapped with title: \(cellTitle)")
        // Perform default action for other cells
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
extension HomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // Handle the selected video URL
        if let videoURL = info[.mediaURL] as? URL {
            // Instantiate the selectMusicVC view controller
            let selectMusicVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectMusicViewController") as! selectMusicVC
            
            // Pass the selected video URL to the selectMusicVC if needed
            selectMusicVC.selectedVideoURL = videoURL // Replace with your property name
            
            // Push the selectMusicVC onto the navigation stack
            navigationController?.pushViewController(selectMusicVC, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
