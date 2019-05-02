//
//  Transaction.swift
//  Borrow
//
//  Created by jackie on 4/17/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import Foundation

class Transaction {
    /** Represents the transaction id. */
    var id: String
    
    /** Represents the borrower's name. */
    var borrower: String
    
    /** Represents the lender's name. */
    var lender: String
    
    /** Represents the borrower's name. */
    var borrowerId: String
    
    /** Represents the lender's name. */
    var lenderId: String
    
    /** Easily checks to see what role you are. */
    var isBorrower: Bool
    
    /** Represents the item description. */
    var item: String
    
    /** Represents the return date and time as a Date object. */
    var dateObj: Date?
    
    /** Represents the return date and time as a String. */
    var dateStr: String
    
    /** Represents the notification preference. */
    var notifications: String
    
    init(id: String, borrower: String, borrowerId: String, lender: String, lenderId: String, isBorrower: Bool, item: String, date: String, notifications: String) {
        self.id = id
        self.borrower = borrower
        self.borrowerId = borrowerId
        self.lender = lender
        self.lenderId = lenderId
        self.isBorrower = isBorrower
        self.item = item
        self.dateStr = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy at h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        if let date = dateFormatter.date(from: date) {
            self.dateObj = date
        }
        
        self.notifications = notifications
    }
    
    func getId() -> String {
        return id
    }
    
    func getBorrower() -> String {
        // should return borrower's name
        return borrower
    }
    
    func getLender() -> String {
        // should return lender's name
        return lender
    }
    
    func getBorrowerId() -> String {
        // should return borrower's name
        return borrowerId
    }
    
    func getLenderId() -> String {
        // should return lender's name
        return lenderId
    }
    
    
    func getItem() -> String {
        return item
    }
 
    func getNotifications() -> String {
        return notifications
    }
    
    func getIsBorrower() -> Bool {
        return isBorrower
    }
    
    func getDateStr() -> String {
        return dateStr
    }
    
    func getDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateObj = dateFormatter.date(from: dateStr)
        return dateObj!
    }
    
    func getTime() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let dateObj = dateFormatter.date(from: dateStr)
        return dateObj!
    }
    
}
