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
        
        // UI related stuff
        itemLabel.text = transaction?.getItem()
        dateLabel.text = transaction?.getDateStr()
        notifLabel.text = transaction?.getNotifications()
        borrowerName.text = transaction?.getBorrower()
        lenderName.text = transaction?.getLender()
        let id = transaction?.getId()
        let imgRef = storageRef.child("transactions").child("\(id ?? "").jpg")
        // Placeholder image
        let placeholderImage = UIImage(named: "noimg")

        pictureImg.sd_setImage(with: imgRef, placeholderImage: placeholderImage)

        // getImage(id: (transaction?.getId())!)
        // pictureImg.image = image
        
    }
    
    func getImage(id: String!) {
        print("what the fuck: \(id ?? "")")
        // Create a reference to the file you want to download
        let imgRef = storageRef.child("transactions").child("\(id ?? "").jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                print("it worked!!!!!!")
                self.image = UIImage(data: data!)
            }
        }
        
    }

}
