import UIKit
import AVFoundation
import Photos

class editPageVc: UIViewController, CanvasVCDelegate,UIGestureRecognizerDelegate  {
    // Implement the delegate method to handle the selected crop option
    func didSelectCropOption(_ cropOption: CropOption) {
        print("Selected crop option:", cropOption)
        applyCropOptionToVideo(cropOption)
    }
    var selectedMusicURL: URL?
    var selectedVideoURL: URL?
    
    var player: AVPlayer?
    var audioPlayer: AVAudioPlayer?
    var videoPlayer: AVPlayer?
    
    @IBOutlet weak var videooView: UIView!
    @IBOutlet weak var musicView: UIView!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var editLeftButtoon: UIBarButtonItem!
    
    var avPlayer: AVPlayer?
    var isPlaying = false
    
    @IBOutlet weak var aiEffectsContainerView: UIView!
    @IBOutlet weak var filtersContainerView: UIView!
    @IBOutlet weak var fontsContainerView: UIView!
    
    @IBOutlet weak var canvasView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    var timeObserver: Any?
    
    let thumbnailInterval: Double = 4.0
    var thumbnails: [UIImage] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var thumbnelView: UIImageView!
    
    var canvasVC: canvasVC?
    var selectedCropOption: CropOption?
        
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tabBar.delegate = self
        
        // Hide the back button
        navigationItem.setHidesBackButton(true, animated: false)
        
        SelectedAudioVideoPlay()
        CoontainerViewsSetUp()
        
        // Add observer for AVPlayerItemDidPlayToEndTime notification
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        editLeftButtoon.title = "New"
        
        // Add a tap gesture recognizer to the image views
        for imageView in scrollView.subviews {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(thumbnailTapped(_:)))
            tapGesture.delegate = self
            imageView.addGestureRecognizer(tapGesture)
        }
        
          if let videoURL = selectedVideoURL {
              setupThumbnailScrollView(for: videoURL)
          }
        timeObserverFunc()
    }
    
    func timeObserverFunc(){
        // Add an observer to update the time label
        timeObserver = videoPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
                  guard let self = self else { return }
                  
                  let currentTime = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(self.videoPlayer?.currentItem?.duration ?? .zero)
                  
                  let currentTimeText = self.timeString(from: currentTime)
                  let durationText = self.timeString(from: duration)
                  
                  self.timeLabel.text = "\(currentTimeText)/\(durationText)"
              }
    }
      
      func timeString(from seconds: Double) -> String {
          let minutes = Int(seconds) / 60
          let remainingSeconds = Int(seconds) % 60
          return String(format: "%02d:%02d", minutes, remainingSeconds)
      }
    @objc func thumbnailTapped(_ gesture: UITapGestureRecognizer) {
        if let imageView = gesture.view as? UIImageView, let player = player {
            let selectedTime = CMTime(seconds: Double(imageView.tag) * thumbnailInterval, preferredTimescale: 1)
            player.seek(to: selectedTime)
            
            // Update the selected thumbnail frame in your thumbnelView
            thumbnelView.image = thumbnails[imageView.tag]
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CanvasVC" {
            if let canvasVC = segue.destination as? canvasVC {
                // Set the delegate of canvasVC to self
                canvasVC.delegate = self
                // Add the debug print statement to check if the delegate is set
                print("Delegate set to:", canvasVC.delegate as Any)
                // Pass any other necessary data to canvasVC
                // Example: canvasVC.someProperty = someValue
            }
        }
    }
    func CoontainerViewsSetUp(){
        aiEffectsContainerView.isHidden = true
        canvasView.isHidden = true
        filtersContainerView.isHidden = true
        fontsContainerView.isHidden = true
    }
    
    func SelectedAudioVideoPlay(){
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

    func setupThumbnailScrollView(for videoURL: URL) {
        thumbnails = generateThumbnails(for: videoURL, at: thumbnailInterval)

        let thumbnailHeight: CGFloat = thumbnelView.frame.size.height
        let thumbnailAspectRatio: CGFloat = thumbnails[0].size.width / thumbnails[0].size.height

        // Calculate the thumbnail width to maintain the aspect ratio
        let thumbnailWidth: CGFloat = thumbnailHeight * thumbnailAspectRatio

        var xPosition: CGFloat = 0.0

        for (index, thumbnail) in thumbnails.enumerated() {
            let imageView = UIImageView(image: thumbnail)
            imageView.frame = CGRect(x: xPosition, y: 0, width: thumbnailWidth, height: thumbnailHeight)
            imageView.contentMode = .scaleAspectFit  // Set content mode to maintain aspect ratio
            imageView.isUserInteractionEnabled = true
            imageView.tag = index
            scrollView.addSubview(imageView)

            xPosition += thumbnailWidth
        }

        scrollView.contentSize = CGSize(width: xPosition, height: thumbnailHeight)
    }
    
    //MARK: CONTAINERVIEWS SHOW-HIDE
    // Function to show a specific container view with animation
    func showContainerView(containerView: UIView) {
        UIView.animate(withDuration: 0.3) {
            containerView.isHidden = false
            containerView.frame.origin.y = self.view.frame.height - containerView.frame.height
        }
        editLeftButtoon.title = "Cancle"
    }
    
    // Function to hide a specific container view with animation
    func hideContainerView(containerView: UIView) {
        UIView.animate(withDuration: 0.3) {
            containerView.frame.origin.y = self.view.frame.height
        } completion: { _ in
            containerView.isHidden = true
        }
        editLeftButtoon.title = "New"
    }
    
    // Example usage when a user taps a tab bar item
    func showEditingOptionForTabBarItem(tabBarItemIndex: Int) {
        // Hide all container views
        aiEffectsContainerView.isHidden = true
        self.canvasView.isHidden = true
        
        filtersContainerView.isHidden = true
        fontsContainerView.isHidden = true
        
        // Show the selected container view
        switch tabBarItemIndex {
        case 0:
            showContainerView(containerView: aiEffectsContainerView)
        case 1:
            
            showContainerView(containerView: canvasView)
        case 2:
            if let selectMusicVc = storyboard?.instantiateViewController(withIdentifier: "SelectMusicViewController") as? selectMusicVC {
                selectMusicVc.selectedVideoURL = selectedVideoURL // Pass the selected video URL
                // Check if a music is already selected and pass it if available
                if let selectedMusicURL = audioPlayer?.url {
                    selectMusicVc.selectedMusicURL = selectedMusicURL
                }
                navigationController?.pushViewController(selectMusicVc, animated: false)
            }
        case 3:
            showContainerView(containerView: filtersContainerView)
        case 4:
            showContainerView(containerView: fontsContainerView)
        default:
            break
        }
    }
    
    // Example usage when a user taps a cancel button in each editing option view
    func hideEditingOptionForTabBarItem(tabBarItemIndex: Int) {
        switch tabBarItemIndex {
        case 0:
            hideContainerView(containerView: aiEffectsContainerView)
        case 1:
            hideContainerView(containerView: self.canvasView)
        case 3:
            hideContainerView(containerView: filtersContainerView)
        case 4:
            hideContainerView(containerView: fontsContainerView)
        default:
            break
        }
    }
    
    // Selector for AVPlayerItemDidPlayToEndTime notification
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        // Pause the audio player here
        audioPlayer?.pause()
    }
    
    // Function to pause the audio player
    func pauseAudioPlayer() {
        if let audioPlayer = audioPlayer {
            if audioPlayer.isPlaying {
                audioPlayer.pause()
            }
        }
    }
    //MARK: generateThumbnails
    func generateThumbnails(for videoURL: URL, at intervals: Double) -> [UIImage] {
        let asset = AVAsset(url: videoURL)
        var thumbnails: [UIImage] = []

        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        let duration = CMTimeGetSeconds(asset.duration)
        let interval = CMTime(seconds: intervals, preferredTimescale: 1)

        for time in stride(from: .zero, to: duration, by: intervals) {
            do {
                let cgImage = try imageGenerator.copyCGImage(at: CMTime(seconds: time, preferredTimescale: 1), actualTime: nil)
                let image = UIImage(cgImage: cgImage)
                thumbnails.append(image)
            } catch {
                print("Error generating thumbnail: \(error)")
            }
        }

        return thumbnails
    }

    //MARK: NAVBAR BUTTONS
    @IBAction func newButtonTapped(_ sender: UIBarButtonItem) {
        
        if editLeftButtoon.title == "New" {
            // If it's not the second tab, show a confirmation alert
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
        else{
            if let tabBar = self.tabBar,
               let selectedIndex = tabBar.selectedItem?.tag {
                
                // Call the function to hide the corresponding container view
                hideEditingOptionForTabBarItem(tabBarItemIndex: selectedIndex)
                
            }
            
        }
    }
    //MARK: SAVE-BUTTON
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
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        // Don't forget to remove the time observer when you're done
        if let timeObserver = timeObserver {
            videoPlayer?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
    }
    
    //MARK: applyCropOption
    private func applyCropOptionToVideo(_ cropOption: CropOption) {
        selectedCropOption = cropOption
        
        // Calculate the video's aspect ratio
        let videoAspectRatio = cropOption.image.size.width / cropOption.image.size.height
        
        // Calculate the video's width based on the height of the videooView
        let videoHeight = videooView.frame.height
        let videoWidth = videoHeight * videoAspectRatio
        
        print("Video width:", videoWidth, "Video height:", videoHeight)
        
        // Find the AVPlayerLayer
        if let playerLayer = videooView.layer.sublayers?.compactMap({ $0 as? AVPlayerLayer }).first {
            // Center the video within the videooView
            let xOffset = (videooView.frame.width - videoWidth) / 2
            let yOffset = (videooView.frame.height - videoHeight) / 2
            playerLayer.frame = CGRect(x: xOffset, y: yOffset, width: videoWidth, height: videoHeight)
        }
    }
}

extension editPageVc: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        videoPlayer?.pause()
        audioPlayer?.pause()
        // You can identify the selected item by its tag or other properties
        if let itemIndex = tabBar.items?.firstIndex(of: item) {
            showEditingOptionForTabBarItem(tabBarItemIndex: itemIndex)
        }
    }
}
