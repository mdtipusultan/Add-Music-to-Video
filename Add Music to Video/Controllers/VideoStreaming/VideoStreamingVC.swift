//
//  VideoStreamingVC.swift
//  Add Music to Video
//
//  Created by Tipu Sultan on 4/10/25.
//

import UIKit
import AVKit

class VideoStreamingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
             let videoURL = URL(string: "https://your-video-url.com/video.mp4")!
             let player = AVPlayer(url: videoURL)
             let playerVC = AVPlayerViewController()
             playerVC.player = player
             
             // Present player
             present(playerVC, animated: true) {
                 player.play()
             }
    }

}
