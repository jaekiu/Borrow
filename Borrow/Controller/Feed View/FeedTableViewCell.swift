//
//  FeedTableViewCell.swift
//  Borrow
//
//  Created by jackie on 4/17/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var borrower: UILabel!
    @IBOutlet weak var lender: UILabel!
    @IBOutlet weak var item: UILabel!
    var transaction: Transaction!
    var viewController : FeedViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePic.setRounded()
        
    }
    
    @IBAction func openProfile(_ sender: Any) {
        let id = transaction?.getBorrowerId()
        databaseRef.child("users").child(id!).observeSingleEvent(of: .value) { (snapshot) in
            var properties = [String: String]()
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                if key != "transactions" {
                    let value = snap.value as! String
                    properties[key] = value
                }
            }
            let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profilePopUp") as! PopUpViewController
            popoverVC.userToView = User(uid: id!, name: properties["name"]!, username: properties["username"]!)
            self.viewController.addChild(popoverVC)
            popoverVC.view.frame = self.viewController.view.bounds
            self.viewController.view.addSubview(popoverVC.view)
            popoverVC.didMove(toParent: self.viewController)
            
        }
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
