//
//  DetailsViewController.swift
//  Borrow
//
//  Created by jackie on 4/17/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit
import FirebaseUI

class DetailsViewController: UIViewController {
    
    
    
    var transaction: Transaction?

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
        
        
        let id = transaction?.getId()
        let placeholderImage = UIImage(named: "noimg")
        let imgRef = storageRef.child("transactions").child("\(id ?? "").jpg")
        pictureImg.sd_setImage(with: imgRef, placeholderImage: placeholderImage)

        
        itemLabel.text = transaction?.getItem()
        dateLabel.text = transaction?.getDateStr()
        notifLabel.text = transaction?.getNotifications()
        borrowerName.text = transaction?.getBorrower()
        lenderName.text = transaction?.getLender()
        // getImage(id: (transaction?.getId())!)
        // pictureImg.image = image
        borrowerImg.setRounded()
        lenderImg.setRounded()
        
        
    }

    @IBAction func openBorrowerProfile(_ sender: Any) {
        let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profilePopUp") as! PopUpViewController
        self.addChild(popoverVC)
        popoverVC.view.frame = self.view.bounds
        self.view.addSubview(popoverVC.view)
        popoverVC.didMove(toParent: self)
    }
    
    @IBAction func openLenderProfile(_ sender: Any) {
        let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profilePopUp") as! PopUpViewController
        self.addChild(popoverVC)
        popoverVC.view.frame = self.view.bounds
        self.view.addSubview(popoverVC.view)
        popoverVC.didMove(toParent: self)
    }
}
