//
//  settingsTableViewCell.swift
//  Add Music to Video
//
//  Created by Tipu on 12/8/23.
//

import UIKit

class settingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoimage: UIImageView!
    @IBOutlet weak var logoTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
