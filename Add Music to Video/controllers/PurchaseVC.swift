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
    
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set corner radius for the top part of downView
        downView.layer.cornerRadius = 20
        downView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        videoPlay()
    }
    func videoPlay(){
        // Create a video URL (replace with your video URL)
        if let videoURL = Bundle.main.url(forResource: "172807 (1080p)", withExtension: "mp4") {
            // Create an AVPlayer with the video URL
            player = AVPlayer(url: videoURL)
            
            // Create an AVPlayerLayer and add it to the videoView's layer
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = videoView.bounds
            videoView.layer.addSublayer(playerLayer)
            
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
