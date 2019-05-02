//
//  MenuViewController.swift
//  Borrow
//
//  Created by jackie on 5/1/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit
import Firebase

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}


class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var btnCloseMenuOverlay: UIButton!
    var delegate : SlideMenuDelegate?

    var btnMenu : UIButton!

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuView.addBorder(toSide: .Left, withColor: UIColor.black.cgColor, andThickness: 1.0)
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.4
        menuView.layer.shadowOffset = CGSize(width: 0, height: 3)

        menuView.layer.shadowRadius = 4.0
    }
    
    

    @IBAction func btnClosedTapped(_ sender: UIButton) {
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(sender.tag)
            if(sender == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "performSignOut", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func goToFeed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "menuToFeedSegue", sender: self)
    }
    
    @IBAction func goToAdd(_ sender: UIButton) {
        self.performSegue(withIdentifier: "menuToAddSegue", sender: self)
    }
    
    @IBAction func goToEditProfile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "menuToEditProfileSegue", sender: self)
    }
    
    @IBAction func signOut(_ sender: Any) {
        signOut()
    }

}
