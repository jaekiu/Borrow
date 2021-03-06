//
//  FeedViewController.swift
//  Borrow
//
//  Created by jackie on 4/10/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAnalytics
import FirebaseDatabase

class FeedViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var transToView: Transaction?
    var borrowerUser: User?
    var lenderUser: User?
    var transactions = [Transaction]()
    var userUsername: String?
    var userName: String?
    var userTransactions = [String]()
    var image: UIImage?
    let redColor = UIColor.red
    let greyColor = UIColor.black.withAlphaComponent(0.5)

    
    @IBAction func performAddSegue(_ sender: Any) {
        performSegue(withIdentifier: "performAddTransactionSegue", sender: sender)
    }
    
    var dummyDataBorrower = ["You borrowed from Sahil Sanghvi.", "Sahil Sanghvi borrowed from you."]
    var dummyDataDesc = ["spicy spicy hot sauce", "bookz"]
    var dummyDataTime = ["Overdue by 3 hours", "Overdue by 1 hour"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()

        navigationController?.navigationBar.barTintColor = UIColor(red: 100/255.0, green: 196/255.0, blue: 226/255.0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]

        let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView
        if statusBar?.responds(to: #selector(setter: UIView.backgroundColor)) ?? false {
            statusBar?.backgroundColor = UIColor(red: 100/255.0, green: 196/255.0, blue: 226/255.0, alpha: 1)
        }
        populateInfo()
        
        self.tableView.reloadData()
        
        addSlideMenuButton()

    }
    
    func populateInfo() {
        // Gets user's actual name.
        databaseRef.child("users").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let id = snap.key
                
                if id == user!.uid {
                    var userProperties = [String: String]()
                    databaseRef.child("users").child(id).observeSingleEvent(of: .value) { (snapshot) in
                        for child in snapshot.children {
                            let snap = child as! DataSnapshot
                            let key = snap.key
                            if key == "transactions" {
                                let value = snap.value as! NSArray
                                let filteredTrans = (value as Array).filter {$0 is String}
                                print(filteredTrans)
                                self.userTransactions = filteredTrans as! [String]
                                print(self.userTransactions)
                            } else {
                                
                                let value = snap.value as! String
                                userProperties[key] = value
                                
                                print("key: \(key) | value: \(value)")
                            }
                        }
                        self.userUsername = userProperties["username"]
                        self.userName = userProperties["name"]
                    }
                    
                    // Get transactions that correspond to the user.
                    databaseRef.child("transactions").observeSingleEvent(of: .value) { (snapshot) in
                        for child in snapshot.children {
                            let snap = child as! DataSnapshot
                            let id = snap.key
                            print(id)
                            if self.userTransactions.contains(id) {
                                print("i'm innnnnN")
                                var transProperties = [String: String]()
                                databaseRef.child("transactions").child(id).observeSingleEvent(of: .value) { (snapshot) in
                                    print("huuuuh")
                                    for child in snapshot.children {
                                        let snap = child as! DataSnapshot
                                        let key = snap.key
                                        let value = snap.value as! String
                                        print("key: \(key) | value: \(value)")
                                        transProperties[key] = value
                                    }
                                    var borrower = transProperties["borrower"]
                                    var lender = transProperties["lender"]
                                    let item = transProperties["item"]
                                    let notifs = transProperties["notifs"]
                                    let date = transProperties["return_by"]
                                    var isBorrower = false
                                    if borrower == self.userUsername {
                                        print("borrower is me")
                                        isBorrower = true
                                        borrower = self.userName
                                        var partyProperties = [String: String]()
                                        databaseRef.child("usernames").child(lender!).observeSingleEvent(of: .value) { (snapshot) in
                                            for child in snapshot.children {
                                                let snap = child as! DataSnapshot
                                                let key = snap.key
                                                let value = snap.value as! String
                                                partyProperties[key] = value
                                            }
                                            lender = partyProperties["name"]
                                            let transaction = Transaction(id: id, borrower: borrower!, borrowerId: user!.uid, lender: lender!, lenderId: partyProperties["uid"]!, isBorrower: isBorrower, item: item!, date: date!, notifications: notifs!)
                                            self.transactions.append(transaction)
                                            print("counting: \(self.transactions.count)")
                                            self.transactions.reverse()
                                            self.tableView.reloadData()
                                        }
                                       
                                        
                                    } else if lender == self.userUsername {
                                        var partyProperties = [String: String]()
                                        databaseRef.child("usernames").child(borrower!).observeSingleEvent(of: .value) { (snapshot) in
                                            for child in snapshot.children {
                                                let snap = child as! DataSnapshot
                                                let key = snap.key
                                                let value = snap.value as! String
                                                partyProperties[key] = value
                                            }
                                            borrower = partyProperties["name"]
                                            lender = self.userName
                                            let transaction = Transaction(id: id, borrower: borrower!, borrowerId: partyProperties["uid"]!, lender: lender!, lenderId: user!.uid, isBorrower: isBorrower, item: item!, date: date!, notifications: notifs!)
                                            self.transactions.append(transaction)
                                            self.transactions.reverse()
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /** Refreshes the Feeds every time the tab is pressed. */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    /** Populates a table cell for the TableView. */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedTableViewCell {
            let transaction = transactions[indexPath.item]
            cell.viewController = self
            cell.item.text = transaction.getItem()
            let isBorrower = transaction.getIsBorrower()
            cell.transaction = transaction
            if isBorrower == true {
                cell.borrower.text = "You"
                cell.borrower.textColor = .black
                cell.lender.text = transaction.getLender()
                cell.lender.textColor = UIColor(red: 100/255.0, green: 196/255.0, blue: 226/255.0, alpha: 1)               
            } else {
                cell.borrower.text = transaction.getBorrower()
                cell.borrower.textColor = UIColor(red: 100/255.0, green: 196/255.0, blue: 226/255.0, alpha: 1)
                cell.lender.text = "you"
                cell.lender.textColor = .black
            }
            cell.timeText.text = transaction.getDateStr()
            if isOverdue(returnDate: transaction.getDateStr()) {
                cell.timeText.textColor = redColor
            } else {
                cell.timeText.textColor = greyColor
            }
            
            let placeholderImage = UIImage(named: "default")
            let imgRef = storageRef.child("users").child("\(transaction.getBorrowerId()).jpg")
            cell.profilePic.sd_setImage(with: imgRef, placeholderImage: placeholderImage)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    /** Sets the height for a cell. */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    /** Handles selection of a row in the TableView. */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.transToView = transactions[indexPath.item]
        performSegue(withIdentifier: "performDetailsSegue", sender: nil)
    }
    
    func getImage(id: String!) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailsViewController {
            dest.transaction = transToView!
        }
    }
    
    func isOverdue(returnDate: String!) -> Bool {
        let currDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"
        let completeDate = "\(dateFormatter.string(from: currDate)) at \(timeFormatter.string(from: currDate))"
        
        let currYear = getYear(dateObj: completeDate)
        let returnYear = getYear(dateObj: returnDate)
        let currMonth = getMonth(dateObj: completeDate)
        let returnMonth = getMonth(dateObj: returnDate)
        let currDay = getDay(dateObj: completeDate)
        let returnDay = getDay(dateObj: returnDate)
        let currHour = getHour(dateObj: completeDate)
        let returnHour = getHour(dateObj: returnDate)
        let currAMPM = getAMPM(dateObj: completeDate)
        let returnAMPM = getAMPM(dateObj: returnDate)
        
        if currYear > returnYear {
            return true
        }
        if currYear == returnYear {
            if currMonth > returnMonth {
                return true
            }
            if currMonth == returnMonth {
                if currDay > returnDay {
                    return true
                }
                if currDay == returnDay {
                    if currHour > returnHour && currAMPM == returnAMPM {
                        return true
                    }
                }
            }
        }
        return false
    }

}
