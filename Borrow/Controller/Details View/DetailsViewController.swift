//
//  DetailsViewController.swift
//  Borrow
//
//  Created by jackie on 4/17/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseDatabase

class DetailsViewController: UIViewController {
    
    
    
    var transaction: Transaction?
    
    @IBOutlet weak var confirmReturnButton: UIButton!
    @IBOutlet weak var borrowerImg: UIImageView!
    @IBOutlet weak var borrowerName: UILabel!
    @IBOutlet weak var lenderImg: UIImageView!
    @IBOutlet weak var lenderName: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notifLabel: UILabel!
    @IBOutlet weak var pictureImg: UIImageView!
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Details"
        navigationController?.navigationBar.barTintColor = UIColor(red: 100/255.0, green: 196/255.0, blue: 226/255.0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        navigationController?.navigationBar.tintColor = .white
        
        borrowerImg.setRounded()
        lenderImg.setRounded()
        confirmReturnButton.setRounded()
        
        if (transaction?.getIsBorrower())! {
            confirmReturnButton.isHidden = true
        } else {
            confirmReturnButton.isHidden = false
        }
        
        // The actual transaction stuff
        let id = transaction?.getId()
        let placeholderImage = UIImage(named: "noimg")
        let imgRef = storageRef.child("transactions").child("\(id ?? "").jpg")
        pictureImg.sd_setImage(with: imgRef, placeholderImage: placeholderImage)
        
        itemLabel.text = transaction?.getItem()
        dateLabel.text = transaction?.getDateStr()
        notifLabel.text = transaction?.getNotifications()
        
        // The user stuff
        borrowerName.text = transaction?.getBorrower()
        lenderName.text = transaction?.getLender()
        let placeholderImageUser = UIImage(named: "default")
        let imgRefBorrower = storageRef.child("users").child("\(transaction!.getBorrowerId() ?? "").jpg")
       borrowerImg.sd_setImage(with: imgRefBorrower, placeholderImage: placeholderImageUser)
        let imgRefLender = storageRef.child("users").child("\(transaction!.getLenderId() ?? "").jpg")
        lenderImg.sd_setImage(with: imgRefLender, placeholderImage: placeholderImageUser)
        
        
    }

    
    @IBAction func confirmReturnClicked(_ sender: Any) {
        alertCancel()
    }
    
    @IBAction func openBorrowerProfile(_ sender: Any) {
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
            self.addChild(popoverVC)
            popoverVC.view.frame = self.view.bounds
            self.view.addSubview(popoverVC.view)
            popoverVC.didMove(toParent: self)
            
        }
    }
    
    
    
    @IBAction func openLenderProfile(_ sender: Any) {
        let id = transaction?.getLenderId()
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
            self.addChild(popoverVC)
            popoverVC.view.frame = self.view.bounds
            self.view.addSubview(popoverVC.view)
            popoverVC.didMove(toParent: self)
            
        }
        
    }
    
    func alertCancel() {
        let alertController = UIAlertController(title: "Confirm Return?", message:
            "Are you sure you want to confirm this return? This transaction will be deleted if you confirm.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            (action: UIAlertAction!) in
            databaseRef.child("transactions").child((self.transaction?.id)!).removeValue()
            self.performSegue(withIdentifier: "detailsToFeedSegue", sender: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {
            (action: UIAlertAction!) in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
 
}
