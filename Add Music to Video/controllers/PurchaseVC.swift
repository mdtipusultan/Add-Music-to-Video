import UIKit
import AVFoundation

class PurchaseVC: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var downView: UIView!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var allTimeButton: UIButton!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var yearAmount: UILabel!
    @IBOutlet weak var monthAmount: UILabel!
    @IBOutlet weak var allTimeAmount: UILabel!
    
    @IBOutlet weak var trailDays1: UILabel!
    @IBOutlet weak var trailDays2: UILabel!
    
    @IBOutlet weak var saveMoneyLabel: UILabel!
    
    @IBOutlet weak var subscrideButton: UIButton!
    
    @IBOutlet weak var subscriptionRenewLable1: UILabel!    
    @IBOutlet weak var subscriptionRenewLable2: UILabel!
    
    
    @IBOutlet weak var mostPopularView: UIView!
    
    
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set corner radius for the top part of downView
        downView.layer.cornerRadius = 20
        downView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        firstView.layer.cornerRadius = 10
        secondView.layer.cornerRadius = 10
        thirdView.layer.cornerRadius = 10
        mostPopularView.layer.cornerRadius = 10
        videoPlay()
        
        
        // Select the first button by default
        yearButton.isSelected = true
        updateLabelColors(for: yearButton)
        updateSubscribeButtonTitle(for: yearButton)
        updateButtonBorders()
    }
    func videoPlay() {
        print("videoView frame: \(videoView.frame)")
        // Create a video URL (replace with your video URL)
        if let videoURL = Bundle.main.url(forResource: "mixkit-macaw-parrot-feeding-on-a-branch-4669-medium", withExtension: "mp4") {
            // Create an AVPlayer with the video URL
            player = AVPlayer(url: videoURL)
            
            // Remove any existing player layer from the videoView
            videoView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Adjust the player layer's frame when the view layout changes
        if let playerLayer = videoView.layer.sublayers?.first as? AVPlayerLayer {
            playerLayer.frame = videoView.bounds
        }
    }


    @IBAction func crossButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func yearButtonTapped(_ sender: UIButton) {
        updateRadioButtons(sender)
        updateLabelColors(for: sender)
        updateSubscribeButtonTitle(for: sender)
        updateButtonBorders()
    }
    
    @IBAction func monthButtonTapped(_ sender: UIButton) {
        updateRadioButtons(sender)
        updateLabelColors(for: sender)
        updateSubscribeButtonTitle(for: sender)
        updateButtonBorders()
  
    }
    
    @IBAction func allTimeButtonTapped(_ sender: UIButton) {
        updateRadioButtons(sender)
        updateLabelColors(for: sender)
        updateSubscribeButtonTitle(for: sender)
        updateButtonBorders()
       
    }
    
    func updateRadioButtons(_ selectedButton: UIButton) {
        let buttons = [yearButton, monthButton, allTimeButton]
        let imageViews = [image1, image2, image3]
       
        for (index, button) in buttons.enumerated() {
            if button == selectedButton {
                button?.isSelected = true
                imageViews[index]?.image = UIImage(systemName: "circle.inset.filled")
                
            } else {
                button?.isSelected = false
                imageViews[index]?.image = UIImage(systemName: "circle")
            }
        }
    }
    
    func updateLabelColors(for button: UIButton) {
        if button == yearButton {
            yearAmount.textColor = .red
            monthAmount.textColor = .white
            allTimeAmount.textColor = .white
            
            image1.tintColor = .systemRed
            image2.tintColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.00)
            image3.tintColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.00)
            
            saveMoneyLabel.isHidden = false
            subscriptionRenewLable1.isHidden = false
            subscriptionRenewLable2.isHidden = false
            
        } else if button == monthButton {
            yearAmount.textColor = .white
            monthAmount.textColor = .red
            allTimeAmount.textColor = .white
            
            saveMoneyLabel.isHidden = true
            subscriptionRenewLable1.isHidden = false
            subscriptionRenewLable2.isHidden = false
            
            image1.tintColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.00)
            image2.tintColor = .systemRed
            image3.tintColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.00)
            
        } else if button == allTimeButton {
            yearAmount.textColor = .white
            monthAmount.textColor = .white
            allTimeAmount.textColor = .red
            
            saveMoneyLabel.isHidden = true
            subscriptionRenewLable1.isHidden = true
            subscriptionRenewLable2.isHidden = true
            
            image1.tintColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.00)
            image2.tintColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.00)
            image3.tintColor = .systemRed
        }
    }
    func updateSubscribeButtonTitle(for button: UIButton) {
        if button == yearButton {
            subscrideButton.setTitle("Subscribe", for: .normal)
        } else if button == monthButton {
            subscrideButton.setTitle("Subscribe", for: .normal)
        } else if button == allTimeButton {
            subscrideButton.setTitle("Purchase", for: .normal)
        }
    }
    func updateButtonBorders() {
        let buttons = [yearButton, monthButton, allTimeButton]

        for button in buttons {
            if button?.isSelected ?? false {
                button?.layer.borderWidth = 2
                button?.layer.borderColor = UIColor.red.cgColor
                button?.layer.cornerRadius = 10
            } else {
                button?.layer.borderWidth = 0
            }
        }
    }
}
