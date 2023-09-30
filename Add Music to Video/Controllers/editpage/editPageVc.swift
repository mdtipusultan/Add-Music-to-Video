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
    
    @IBOutlet weak var editLeftButtoon: UIBarButtonItem!
    
    var stopButton: UIButton!
    var avPlayer: AVPlayer?
    var isPlaying = false
    
    @IBOutlet weak var aiEffectsContainerView: UIView!
    @IBOutlet weak var canvasContainerView: UIView!
    @IBOutlet weak var filtersContainerView: UIView!
    @IBOutlet weak var fontsContainerView: UIView!
    
    var aiEffectsView: AIEffectsView?
    var canvasView: CanvasView?
    var filtersView: FiltersView?
    var fontsView: FontsView?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tabBar.delegate = self
        
        // Hide the back button
        navigationItem.setHidesBackButton(true, animated: false)
        
        SelectedAudioVideoPlay()
        CoontainerViewsSetUp()
        // Add tap gesture recognizer to videooView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped))
        videooView.addGestureRecognizer(tapGestureRecognizer)
        stopoButton()
        // Add observer for AVPlayerItemDidPlayToEndTime notification
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func CoontainerViewsSetUp(){
        aiEffectsView = AIEffectsView()
        canvasView = CanvasView()
        
        filtersView = FiltersView()
        fontsView = FontsView()
        
        // Add custom views as subviews to container views
        aiEffectsContainerView.addSubview(aiEffectsView!)
        canvasContainerView.addSubview(canvasView!)
        filtersContainerView.addSubview(filtersView!)
        fontsContainerView.addSubview(fontsView!)
        
        // Hide custom views initially
        aiEffectsContainerView.isHidden = true
        canvasContainerView.isHidden = true
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
    //MARK: CONTAINERVIEWS SHOOW-HIDE
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
        canvasContainerView.isHidden = true
        
        filtersContainerView.isHidden = true
        fontsContainerView.isHidden = true
        
        // Show the selected container view
        switch tabBarItemIndex {
        case 0:
            showContainerView(containerView: aiEffectsContainerView)
        case 1:
            showContainerView(containerView: canvasContainerView)
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
            hideContainerView(containerView: canvasContainerView)
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
    func stopoButton(){
        
        // Create and configure the stop button
        stopButton = UIButton(type: .custom)
        stopButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        stopButton.tintColor = UIColor.white
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.isHidden = true // Initially hide the button
        
        // Add the stop button as a subview of videooView
        videooView.addSubview(stopButton)
        
        // Center the stop button in the videooView
        NSLayoutConstraint.activate([
            stopButton.centerXAnchor.constraint(equalTo: videooView.centerXAnchor),
            stopButton.centerYAnchor.constraint(equalTo: videooView.centerYAnchor)
        ])
        
        // Setup AVPlayer for video and audio
        if let selectedVideoURL = selectedVideoURL {
            avPlayer = AVPlayer(url: selectedVideoURL)
            let playerLayer = AVPlayerLayer(player: avPlayer)
            playerLayer.videoGravity = .resizeAspect
            videooView.layer.addSublayer(playerLayer)
            avPlayer?.play()
            playerLayer.frame = videooView.bounds
            playerLayer.contentsGravity = .center
        }
        
        stopButton.isUserInteractionEnabled = false
    }
    
    @objc func videoViewTapped() {
        if let avPlayer = avPlayer {
            if isPlaying {
                avPlayer.pause()
                audioPlayer?.pause()
                stopButton.isHidden = false
                isPlaying = false
            } else {
                avPlayer.play()
                audioPlayer?.play()
                stopButton.isHidden = true
                isPlaying = true
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
    //MARK: NAVBAR BUTTONS
    @IBAction func newButtonTapped(_ sender: UIBarButtonItem) {
        if let tabBar = self.tabBar,
           let selectedIndex = tabBar.selectedItem?.tag {
            
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
                // Call the function to hide the corresponding container view
                hideEditingOptionForTabBarItem(tabBarItemIndex: selectedIndex)
            }
            
            
        }
        
        
        
        
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
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
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
