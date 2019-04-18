//
//  AddTransactionViewController.swift
//  Borrow
//
//  Created by jackie on 4/17/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit
import Eureka

class AddTransactionViewController: FormViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = nil
        let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView
        if statusBar?.responds(to: #selector(setter: UIView.backgroundColor)) ?? false {
            statusBar?.backgroundColor = nil
        }
        
        // Eureka Form
        form +++ Section("Other Party")
            <<< TextAreaRow(){
                $0.placeholder = "Username"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 23)
            }
//            <<< TextRow(){ row in
//                row.title = "Other Party"
//                row.placeholder = "Username"
//            }
            +++ Section("Item")
            <<< TextAreaRow(){
                $0.placeholder = "Description of Item"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 150)
            }
            +++ Section("Settings")
            <<< DateRow(){
                $0.title = "Return Date"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }
            <<< PushRow<String>() { row in
                row.title = "Notifications"
                row.options = ["Every Month", "Every Week", "Every Day", "Every 3 Hours", "Every Hour"]
            }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func cancelTransaction(_ sender: Any) {
        alertCancel()
    }
    
    @IBAction func saveTransaction(_ sender: Any) {
        performSegue(withIdentifier: "backToFeed", sender: sender)
    }
    
    func finishTransaction() {
        
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
