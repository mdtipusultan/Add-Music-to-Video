//
//  selectMusicVC.swift
//  Add Music to Video
//
//  Created by Tipu on 16/8/23.
//

import UIKit
import Reachability
import MediaPlayer

class selectMusicVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var coleectionview: UICollectionView!
    
    var selectedVideoURL: URL?
    var reachability: Reachability!
    /*
     // Example data for the second section
     let albumData: [[String: Any]] = [
     ["title": "Album 1", "coverImage": UIImage(named: "album1_cover")!, "song": "Song 1"],
     ["title": "Album 2", "coverImage": UIImage(named: "album2_cover")!, "song": "Song 2"],
     // ... add more albums as needed
     ]
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coleectionview.dataSource = self
        coleectionview.delegate = self
        
        // Set up Reachability
        reachability = try? Reachability()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReachabilityChanged(_:)), name: .reachabilityChanged, object: nil)
        
        try? reachability.startNotifier()
    }
    @objc func handleReachabilityChanged(_ notification: Notification) {
        if let reachability = notification.object as? Reachability {
            if reachability.connection != .unavailable {
                coleectionview.reloadData() // Reload the collection view to update sections
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the back button
        navigationItem.setHidesBackButton(true, animated: false)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Prevent the navigation bar from hiding from scroll
        navigationController?.hidesBarsOnSwipe = false
        
        
        // Configure collection view layout
        if let layout = coleectionview.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 10 // Adjust the spacing between cells horizontally
            layout.minimumLineSpacing = 10 // Adjust the spacing between cells vertically
            
            let itemWidth = (coleectionview.bounds.width - layout.minimumInteritemSpacing) / 2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth) // Set item size to create two cells per row
        }
    }
    
    
    @IBAction func skipButtonTapped(_ sender: UIBarButtonItem) {
        // Set selectedMusicURL to nil
             let selectedMusicURL: URL? = nil
             
             // Instantiate the editPageVc view controller
             let storyboard = UIStoryboard(name: "Main", bundle: nil) // Update with your storyboard name
             if let editPageVC = storyboard.instantiateViewController(withIdentifier: "editPage") as? editPageVc {
                 editPageVC.selectedMusicURL = selectedMusicURL // Pass the selected music URL (which is nil)
                 editPageVC.selectedVideoURL = selectedVideoURL // Pass the selected video URL
                 navigationController?.pushViewController(editPageVC, animated: true)
             }
        
    }
    
    // MARK: COLLECTIONVIEW
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return reachability?.connection != .unavailable ? 2 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2 // Number of cells in the first section
        } else {
            return 10/* Number of cells in the second section */
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            // Configure and return the first section cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! selectMusicCollectionViewCell
            // Configure the cell using your data
            if indexPath.row == 0 {
                cell.logoIImageview.image = UIImage(systemName: "music.note")
                cell.logoName.text = "My Music"
            } else if indexPath.row == 1 {
                cell.logoIImageview.image = UIImage(systemName: "mic")
                cell.logoName.text = "Record"
            }
            return cell
        } else {
            // Configure and return the second section cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! DownloadSelectMusicCollectionViewCell
            
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // User tapped on the first cell in the first section
                openMusicTracks()
            }
            // Handle other cases if needed
        }
    }
    func openMusicTracks() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    // MARK: COLLECTIONVIEW FLOW LAYOUT
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = (collectionViewWidth - 20) / 2 // Adjust the spacing between cells horizontally
        print(itemWidth)
        return CGSize(width: itemWidth, height: 150) // Set item size to create two cells per row
    }
}

extension selectMusicVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedMusicURL = urls.first else {
            return
        }
        
        // Assume you already have the selectedVideoURL set elsewhere in your code
        
        // Instantiate the editPageVc view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Update with your storyboard name
        if let editPageVC = storyboard.instantiateViewController(withIdentifier: "editPage") as? editPageVc {
            editPageVC.selectedMusicURL = selectedMusicURL // Pass the selected music URL
            editPageVC.selectedVideoURL = selectedVideoURL // Pass the selected video URL
            navigationController?.pushViewController(editPageVC, animated: true)
        }
    }
    // Handle other delegate methods
}
