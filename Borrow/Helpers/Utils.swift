//
//  Utils.swift
//  Borrow
//
//  Created by jackie on 4/17/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
}

extension UIButton {
    
    func setRounded() {
        self.layer.cornerRadius = 18
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 100/255.0, green: 196/255.0, blue: 226/255.0, alpha: 1).cgColor
        
    }

}

extension UIView {
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}


func getYear(dateObj: String!) -> Int {
    let start = dateObj.index(dateObj.startIndex, offsetBy: 7)
    let end = dateObj.index(dateObj.startIndex, offsetBy: 11)
    let range = start..<end
    return Int(String(dateObj[range]))!
}

func getMonth(dateObj: String!) -> Int {
    let start = dateObj.index(dateObj.startIndex, offsetBy: 3)
    let end = dateObj.index(dateObj.startIndex, offsetBy: 6)
    let range = start..<end
    let month = String(dateObj[range])
    switch month {
    case "Jan":
        return 1
    case "Feb":
        return 2
    case "Mar":
        return 3
    case "Apr":
        return 4
    case "May":
        return 5
    case "Jun":
        return 6
    case "Jul":
        return 7
    case "Aug":
        return 8
    case "Sep":
        return 9
    case "Oct":
        return 10
    case "Nov":
        return 11
    case "Dec":
        return 12
    default:
        return 0
    }
}

func getDay(dateObj: String!) -> Int {
    let start = dateObj.index(dateObj.startIndex, offsetBy: 0)
    let end = dateObj.index(dateObj.startIndex, offsetBy: 2)
    let range = start..<end
    return Int(String(dateObj[range]))!
}

func getHour(dateObj: String!) -> Int {
    if dateObj.length == 22 {
        return Int(String(dateObj[15]))!
    } else {
        return Int(String(dateObj[15]))! * 10 + Int(String(dateObj[16]))!
    }
    
}

func getAMPM(dateObj: String!) -> String {
    return dateObj.substring(fromIndex: 19)
}

extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
