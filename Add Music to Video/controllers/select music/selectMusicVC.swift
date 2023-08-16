//
//  selectMusicVC.swift
//  Add Music to Video
//
//  Created by Tipu on 16/8/23.
//

import UIKit
import Reachability


class selectMusicVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var coleectionview: UICollectionView!
    
    var selectedVideoURL: URL?
    
    
    var reachability: Reachability!


    
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
        
        // Prevent the navigation bar from hiding on scroll
        navigationController?.hidesBarsOnSwipe = false
        
        
        // Configure collection view layout
        if let layout = coleectionview.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 10 // Adjust the spacing between cells horizontally
            layout.minimumLineSpacing = 10 // Adjust the spacing between cells vertically
            
            let itemWidth = (coleectionview.bounds.width - layout.minimumInteritemSpacing) / 2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth) // Set item size to create two cells per row
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
            return cell
        } else {
            // Configure and return the second section cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! DownloadSelectMusicCollectionViewCell
            // Configure the cell using your data
            return cell
        }
    }
    // MARK: COLLECTIONVIEW FLOW LAYOUT
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = (collectionViewWidth - 10) / 2 // Adjust the spacing between cells horizontally
        
        return CGSize(width: itemWidth, height: 150) // Set item size to create two cells per row
    }
}
