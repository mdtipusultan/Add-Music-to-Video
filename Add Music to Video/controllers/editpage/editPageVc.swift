import UIKit
import AVFoundation
import Photos

class editPageVc: UIViewController {
    
    var selectedMusicURL: URL?
    var selectedVideoURL: URL?
    
    var player: AVPlayer?
    var audioPlayer: AVAudioPlayer?
    var videoPlayer: AVPlayer?
    
    @IBOutlet weak var videooView: UIView!
    @IBOutlet weak var musicView: UIView!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tabBar.delegate = self
        
        // Hide the back button
        navigationItem.setHidesBackButton(true, animated: false)
        
        if let selectedVideoURL = selectedVideoURL {
            videoPlayer = AVPlayer(url: selectedVideoURL)
            let playerLayer = AVPlayerLayer(player: videoPlayer)
            
            playerLayer.videoGravity = .resizeAspect // Set videoGravity to resizeAspect
            videooView.layer.addSublayer(playerLayer)
            videoPlayer?.play()
            
            // Update playerLayer's frame to center the video within the videooView
            playerLayer.frame = videooView.bounds
            playerLayer.contentsGravity = .center
        }
        
        // Play the selected music
        if let selectedMusicURL = selectedMusicURL {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: selectedMusicURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error playing audio: \(error)")
            }
        }
    }
    
    // Function to pause the audio player
    func pauseAudioPlayer() {
        if let audioPlayer = audioPlayer {
            if audioPlayer.isPlaying {
                audioPlayer.pause()
            }
        }
    }
    
    @IBAction func newButtonTapped(_ sender: UIBarButtonItem) {
        // Show a confirmation alert
        let alertController = UIAlertController(title: "Confirm", message: "Are you sure you want to go back to the home screen?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            // Navigate back to the root view controller (HomeVC)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Function to save the video with music and clip the music
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let selectedVideoURL = selectedVideoURL else {
            return
        }
        
        // Pause the audio player before exporting
        pauseAudioPlayer()
        
        // Create a video composition
        let composition = AVMutableComposition()
        
        // Video track
        let videoAsset = AVAsset(url: selectedVideoURL)
        let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        try? videoTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: .video)[0], at: .zero)
        
        // Music track (only if there's a selectedMusicURL)
        if let selectedMusicURL = selectedMusicURL {
            let musicAsset = AVAsset(url: selectedMusicURL)
            let musicTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            try? musicTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.duration), of: musicAsset.tracks(withMediaType: .audio)[0], at: .zero)
        }
        
        // Export the composition
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputFileType = .mov // Adjust the desired output format
        
        // Create a URL for the output file in the Documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputFileName = "output_\(Date().timeIntervalSince1970).mov" // Using timestamp as part of the file name
        let outputURL = documentsDirectory.appendingPathComponent(outputFileName)
        
        exportSession?.outputURL = outputURL
        
        exportSession?.exportAsynchronously {
            if exportSession?.status == .completed {
                // Save the video to the photo library
                self.saveToGallery(url: outputURL)
            } else {
                print("Export failed: \(exportSession?.error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func saveToGallery(url: URL?) {
        guard let videoURL = url else {
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
        }) { success, error in
            if success {
                print("Video saved to gallery")
            } else if let error = error {
                print("Error saving video to gallery: \(error)")
            }
        }
    }
}
extension editPageVc: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        videoPlayer?.pause()
        audioPlayer?.pause()
        if let navigationController = navigationController {
            switch item.tag {
            case 0:
                if let firstTabVc = storyboard?.instantiateViewController(withIdentifier: "FirstTabViewController") {
                    navigationController.setViewControllers([firstTabVc], animated: false)
                }
            case 1:
                if let canvasVC = storyboard?.instantiateViewController(withIdentifier: "CanvasVC") as? CanvasVC {
                    navigationController.pushViewController(canvasVC, animated: true)
                }
            case 2:
                if let selectMusicVc = storyboard?.instantiateViewController(withIdentifier: "SelectMusicViewController") as? selectMusicVC {
                    selectMusicVc.selectedVideoURL = selectedVideoURL // Pass the selected video URL
                    // Check if a music is already selected and pass it if available
                    if let selectedMusicURL = audioPlayer?.url {
                        selectMusicVc.selectedMusicURL = selectedMusicURL
                    }
                    navigationController.pushViewController(selectMusicVc, animated: false)
                }
            case 3:
                if let fourthTabVc = storyboard?.instantiateViewController(withIdentifier: "FourthTabViewController") {
                    navigationController.setViewControllers([fourthTabVc], animated: false)
                }
            case 4:
                if let fifthTabVc = storyboard?.instantiateViewController(withIdentifier: "FifthTabViewController") {
                    navigationController.setViewControllers([fifthTabVc], animated: false)
                }
            default:
                break
            }
        }
    }
}
