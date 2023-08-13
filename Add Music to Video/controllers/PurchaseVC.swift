//
//  PurchaseVC.swift
//  Add Music to Video
//
//  Created by Tipu on 11/8/23.
//

import UIKit
import AVFoundation

class PurchaseVC: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!

    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set corner radius for the top part of downView
        downView.layer.cornerRadius = 20
        downView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        firstView.layer.cornerRadius = 10
        secondView.layer.cornerRadius = 10
        thirdView.layer.cornerRadius = 10
        videoPlay()
    }
    func videoPlay() {
        print("videoView frame: \(videoView.frame)")
        // Create a video URL (replace with your video URL)
        if let videoURL = Bundle.main.url(forResource: "mixkit-macaw-parrot-feeding-on-a-branch-4669-medium", withExtension: "mp4") {
            // Create an AVPlayer with the video URL
            player = AVPlayer(url: videoURL)
            
      
           
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill // Try different settings here
            playerLayer.frame = videoView.bounds
            videoView.layer.addSublayer(playerLayer)

            videoView.layoutIfNeeded() // Try adding this line
            
            player?.play()
            videoView.layer.addSublayer(playerLayer)
            // Print frames for debugging
               print("videoView frame: \(videoView.frame)")
               print("playerLayer frame: \(playerLayer.frame)")
            // Start playing the video
            player?.play()
            
            // Loop the video continuously
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
                self?.player?.seek(to: CMTime.zero)
                self?.player?.play()
            }
        }
    }





    @IBAction func crossButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true)
    }
}
