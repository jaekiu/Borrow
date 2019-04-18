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

class AddTransactionViewController: FormViewController {

    
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
                $0.hidden = "$roles != 'Lender'"
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
        // should also check if its a valid username
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
        
        // Retrieves your role
        let role = valuesDictionary["roles"] as? String
        var borrower = ""
        var lender = ""
        databaseRef.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            if role == "Borrower" {
                borrower = name
                lender = party!
            } else {
                lender = name
                borrower = party!
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        // Inserts to database
        let newRef = databaseRef.child("transactions").childByAutoId()
        newRef.setValue(["lender": lender, "borrower": borrower, "item": item, "return_by": completeDate, "notifs": notif])
        databaseRef.child("users").child(user!.uid).updateChildValues(["transactions": [newRef.key]])

        // Switch to Feed View Controller
        performSegue(withIdentifier: "backToFeed", sender: nil)
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
