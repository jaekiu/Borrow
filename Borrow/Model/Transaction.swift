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
    
    /** Represents the borrower's username. */
    var borrower: String
    
    /** Represents the lender's username. */
    var lender: String
    
    /** Easily checks to see what role you are. */
    var isBorrower: Bool
    
    /** Represents the item description. */
    var item: String
    
    /** Represents the return date and time. */
    var date: Date
    
    /** Represents the notification preference. */
    var notifications: String
    
    init(id: String, borrower: String, lender: String, isBorrower: Bool, item: String, date: Date, notifications: String) {
        self.id = id
        self.borrower = borrower
        self.lender = lender
        self.isBorrower = isBorrower
        self.item = item
        self.date = date
        self.notifications = notifications
    }
    
    func getId() -> String {
        return id
    }
    
    func getBorrower() -> String {
        // should return borrower's name but for now it'll return the username
        return borrower
    }
    
    func getLender() -> String {
        // should return lender's name but for now it'll return the username
        return lender
    }
    
    func getItem() -> String {
        return item
    }
    
 
    func getNotifications() -> String {
        return notifications
    }
    
//    func formatFeedText() -> String {
//        var subject = ""
//        if isBorrower {
//            subject = "You"
//        } else {
//            subject = borrower
//        }
//    }
    
}
