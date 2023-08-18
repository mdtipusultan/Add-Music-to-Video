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

    override func viewDidLoad(){
        super.viewDidLoad()
        
        // Hide the back button
        navigationItem.setHidesBackButton(true, animated: false)
        
        if let selectedVideoURL = selectedVideoURL {
            videoPlayer = AVPlayer(url: selectedVideoURL)
            let playerLayer = AVPlayerLayer(player: videoPlayer)
            
            playerLayer.videoGravity = .resizeAspect // Set videoGravity to resizeAspect
            playerLayer.frame = videooView.bounds
            videooView.layer.addSublayer(playerLayer)
            videoPlayer?.play()
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
