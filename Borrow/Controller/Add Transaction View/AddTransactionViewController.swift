//
//  AddTransactionViewController.swift
//  Borrow
//
//  Created by jackie on 4/17/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import FirebaseDatabase

class AddTransactionViewController: FormViewController {

    var id: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = nil
        navigationController?.navigationBar.tintColor = nil
        let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView
        if statusBar?.responds(to: #selector(setter: UIView.backgroundColor)) ?? false {
            statusBar?.backgroundColor = nil
        }
        
        // Eureka Form
        form
            +++ Section("Select Your Role")
            <<< SegmentedRow<String>("roles"){
                $0.options = ["Borrower", "Lender"]
                $0.value = "Borrower"
            }
            
            +++ Section("Other Party")
            <<< TextAreaRow("party"){
                $0.placeholder = "Username"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 23)
            }
            +++ Section("Item")
            <<< TextAreaRow("item"){
                $0.placeholder = "Description of Item"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 150)
            }
            +++ Section("Settings")
            <<< DateRow("return date"){
                $0.title = "Return Date"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }
            <<< TimeRow("return time"){
                $0.title = "Return Time"
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                formatter.amSymbol = "AM"
                formatter.pmSymbol = "PM"
                $0.dateFormatter = formatter
                $0.value = Date()
            }
            <<< PushRow<String>("notifs") { row in
                row.title = "Notifications"
                row.options = ["Every Month", "Every Week", "Every Day", "Every 3 Hours", "Every Hour"]
            }
            +++ Section("Condition of Item") {
                $0.tag = "lenderImg"
//                $0.hidden = "$roles != 'Lender'"
            }
            <<< ImageRow("img") {
                $0.title = "Attachment"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                $0.clearAction = .yes(style: .destructive)
                
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func cancelTransaction(_ sender: Any) {
        alertCancel()
    }
    
    @IBAction func saveTransaction(_ sender: Any) {
        finishTransaction()
    }
    
    func finishTransaction() {
        // Retrieves all the values
        let valuesDictionary = form.values()
        
        // Retrieves the other party
        let party = valuesDictionary["party"] as? String
        if (party == nil || party == "") {
            alertBadParty()
            return
        }
        
        // Retrieves the item description
        let item = valuesDictionary["item"] as? String
        if (item == nil || item == "") {
            alertBadDescription()
            return
        }
        
        // Retrieves the notification preference
        let notif = valuesDictionary["notifs"] as? String
        if (notif == nil) {
            alertBadNotifications()
            return
        }
        
        // Retrieves date and sets date formatting
        let date = valuesDictionary["return date"] as? Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        let time = valuesDictionary["return time"] as? Date
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"
        
        let completeDate = "\(dateFormatter.string(from: date!)) at \(timeFormatter.string(from: time!))"

        
        // Retrieves image
        let image = valuesDictionary["img"]
        
        // Retrieves your role
        let role = valuesDictionary["roles"] as? String
        var borrower = ""
        var lender = ""
        databaseRef.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            if username.lowercased() == party?.lowercased() {
                self.alertBadParty()
                return
            } else {
                if role == "Borrower" {
                    borrower = username
                    lender = party!
                } else {
                    lender = username
                    borrower = party!
                    if image == nil {
                        self.alertBadImg()
                        return
                    }
                }
                databaseRef.child("usernames/\(party!.lowercased())").observeSingleEvent(of: .value, with: { (snapshot) in
                    if !snapshot.exists(){
                        self.alertBadParty()
                        return
                    } else {
                        // Inserts to database
                        let newRef = databaseRef.child("transactions").childByAutoId()
                        self.id = newRef.key
                        newRef.setValue(["lender": lender.lowercased(), "borrower": borrower.lowercased(), "item": item, "return_by": completeDate, "notifs": notif])
                       
                        databaseRef.child("users").child(user!.uid).observeSingleEvent(of: .value) { (snapshot) in
                            var allTransactions = [String]()
                            for child in snapshot.children {
                                let snap = child as! DataSnapshot
                                let key = snap.key
                                if key == "transactions" {
                                    allTransactions = snap.value as! [String]
                                }
                            }
                            allTransactions.append(newRef.key!)
                            databaseRef.child("users").child(user!.uid).updateChildValues(["transactions": allTransactions])
                        }
                        
                        // Get uid of other party
                        var partyProperties = [String: String]()
                        for child in snapshot.children {
                            let snap = child as! DataSnapshot
                            let key = snap.key
                            let value = snap.value as! String
                            partyProperties[key] = value
                        }
                        databaseRef.child("users").child(user!.uid).observeSingleEvent(of: .value) { (snapshot) in
                            var allTransactions = [String]()
                            for child in snapshot.children {
                                let snap = child as! DataSnapshot
                                let key = snap.key
                                if key == "transactions" {
                                    allTransactions = snap.value as! [String]
                                }
                            }
                            allTransactions.append(newRef.key!)
                            databaseRef.child("users").child(partyProperties["uid"]!).updateChildValues(["transactions": allTransactions])
                        }
//                        databaseRef.child("users").child(partyProperties["uid"]!).updateChildValues(["transactions": [newRef.key]])
                        if let image = valuesDictionary["img"] as? UIImage {
                            self.uploadImagePic(img: image)
                        } else {
                            self.uploadImagePic(img: UIImage(named: "noimg")!)
                        }
                       
                        // Switch to Feed View Controller
                        self.performSegue(withIdentifier: "backToFeed", sender: nil)
                    }
                })
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func uploadImagePic(img: UIImage){
        let data = img.jpegData(compressionQuality: 0.8)
        
        let imgRef = storageRef.child("transactions").child("\(id ?? "").jpg")
        imgRef.putData(data!, metadata: nil){ (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            imgRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        
    }
    
    /** -------- ALERTS --------- */
    
    func alertBadParty() {
        let alertController = UIAlertController(title: "Error!", message:
            "Please input a valid username.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertBadDescription() {
        let alertController = UIAlertController(title: "Error!", message:
            "Please input a valid item description.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertBadNotifications() {
        let alertController = UIAlertController(title: "Error!", message:
            "Please select a notification preference.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertBadImg() {
        let alertController = UIAlertController(title: "Error!", message:
            "Please upload a valid image.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertCancel() {
        let alertController = UIAlertController(title: "Canceling Transaction", message:
            "Are you sure you want to cancel this transaction? All changes made will be lost.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            (action: UIAlertAction!) in self.performSegue(withIdentifier: "backToFeed", sender: nil)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .destructive, handler: {
            (action: UIAlertAction!) in self.finishTransaction()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
