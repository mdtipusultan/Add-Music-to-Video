//
//  SettingsVC.swift
//  Add Music to Video
//
//  Created by Tipu on 11/8/23.
//

import UIKit

class SettingsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var logoView: UIView!
    
    @IBOutlet weak var tableview: UITableView!
    let section1Titles = ["Add Music to Video Pro", "Restore Purchase"]
    let section2Titles = ["Tutorial", "Review", "Contact Support", "More Apps", "Terms of Use", "Privacy Policy"]
    let section1Images = ["crown.fill", "repeat.circle.fill"]
    let section2Images = ["lightbulb.circle.fill", "heart.rectangle", "ellipsis.message.fill", "ellipsis.rectangle.fill", "note.text", "beats.powerbeatspro.chargingcase.fill"]
    
    let tintColors: [UIColor] = [.systemBlue, .systemRed, .blue, .systemYellow, .systemPurple, .systemGreen]
    let tintColors2: [UIColor] = [.systemPurple, .systemGreen]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoView.layer.cornerRadius = 10
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .none
    }
    
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: TABLEVIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! settingsTableViewCell
        
        // Configure cell contents based on section and row
        if indexPath.section == 0 {
            cell.logoimage.image = UIImage(systemName: section1Images[indexPath.row])
            cell.logoTitle.text = section1Titles[indexPath.row]
            // Set the tint color for the image
            cell.logoimage.tintColor = tintColors2[indexPath.row]
        } else {
            cell.logoimage.image = UIImage(systemName: section2Images[indexPath.row])
            cell.logoTitle.text = section2Titles[indexPath.row]
            // Set the tint color for the image
            cell.logoimage.tintColor = tintColors[indexPath.row]
        }
        // Set rounded corners for all sections
        if indexPath.row == 0 {
            // First row in section, add top and bottom rounded corners
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            // Last row in section, add bottom rounded corners
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            // Middle rows in section, reset corner radius and corners mask
            cell.layer.cornerRadius = 0
            cell.layer.maskedCorners = []
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the selected row immediately
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Retrieve the selected cell
        let cell = tableView.cellForRow(at: indexPath) as! settingsTableViewCell
        
        // Perform actions based on the selected section and row
        if indexPath.section == 0 {
            // Handle actions for section 0
            if indexPath.row == 0 {
                // Handle the "Add Music to Video Pro" cell
                print("Add Music to Video Pro cell tapped")
            } else if indexPath.row == 1 {
                // Handle the "Restore Purchase" cell
                print("Restore Purchase cell tapped")
            }
        } else {
            // Handle actions for section 1
            if indexPath.row == 0 {
                // Handle the "Tutorial" cell
                print("Tutorial cell tapped")
            } else if indexPath.row == 1 {
                // Handle the "Review" cell
                print("Review cell tapped")
            } else if indexPath.row == 2 {
                // Handle the "Contact Support" cell
                print("Contact Support cell tapped")
            } else if indexPath.row == 3 {
                // Handle the "More Apps" cell
                print("More Apps cell tapped")
            } else if indexPath.row == 4 {
                // Handle the "Terms of Use" cell
                print("Terms of Use cell tapped")
            } else if indexPath.row == 5 {
                // Handle the "Privacy Policy" cell
                print("Privacy Policy cell tapped")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Return the desired height for the section header to create spacing
        return 20.0 // Adjust this value as needed
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Create an empty view to act as the section header
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        return headerView
    }
}
