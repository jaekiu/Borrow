//
//  FeedViewController.swift
//  Borrow
//
//  Created by jackie on 4/10/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit
import FirebaseAuth

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    @IBOutlet var gestureScreenEdgePan: UIScreenEdgePanGestureRecognizer!
//    let maxBlackViewAlpha:CGFloat = 0.5
    
    
    @IBAction func performAddSegue(_ sender: Any) {
        performSegue(withIdentifier: "performAddTransactionSegue", sender: sender)
        
    }
    let dummyDataBorrower = ["You borrowed from Sahil Sanghvi.", "Sahil Sanghvi borrowed from you."]
    let dummyDataDesc = ["spicy spicy hot sauce", "bookz"]
    let dummyDataTime = ["Overdue by 3 hours", "Overdue by 1 hour"]
    
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
        


        // Hamburger Menu
//        constraintMenuLeft.constant = -constraintMenuWidth.constant
//        viewBlack.alpha = 0
//        viewBlack.isHidden = true
//        viewMenu.isHidden = true
        
    }
    
    /** Refreshes the Feeds every time the tab is pressed. */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyDataBorrower.count
    }
    
    /** Populates a table cell for the TableView. */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedTableViewCell {
            if let url = URL(string: "https://jacquelinezhang.com/Media/innodteamphoto-2059.jpg"){
                DispatchQueue.global().async {
                    if let data = try? Data( contentsOf:url)
                    {
                        DispatchQueue.main.async {
                           cell.profilePic.image = UIImage( data:data)
                        }
                    }
                }
            }
            
            cell.item.text = dummyDataDesc[indexPath.item]
            cell.borrowingText.text = dummyDataBorrower[indexPath.item]
            cell.timeText.text = dummyDataTime[indexPath.item]
        
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
        performSegue(withIdentifier: "performDetailsSegue", sender: nil)
    }
    
    @IBAction func openHamburger(_ sender: Any) {
        // openMenu()
        signOut()
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
//
//    func openMenu() {
//
//        // when menu is opened, it's left constraint should be 0
//        constraintMenuLeft.constant = 0
//
//        // view for dimming effect should also be shown
//        viewBlack.isHidden = false
//
//        // animate opening of the menu - including opacity value
//        UIView.animate(withDuration: 0.3, animations: {
//            self.view.layoutIfNeeded()
//            self.viewBlack.alpha = self.maxBlackViewAlpha
//        }, completion: { (complete) in
//
//            // disable the screen edge pan gesture when menu is fully opened
//            self.gestureScreenEdgePan.isEnabled = false
//        })
//    }
//
//    func hideMenu() {
//
//        // when menu is closed, it's left constraint should be of value that allows it to be completely hidden to the left of the screen - which is negative value of it's width
//        constraintMenuLeft.constant = -constraintMenuWidth.constant
//
//        // animate closing of the menu - including opacity value
//        UIView.animate(withDuration: 0.3, animations: {
//            self.view.layoutIfNeeded()
//            self.viewBlack.alpha = 0
//        }, completion: { (complete) in
//
//            // reenable the screen edge pan gesture so we can detect it next time
//            self.gestureScreenEdgePan.isEnabled = true
//
//            // hide the view for dimming effect so it wont interrupt touches for views underneath it
//            self.viewBlack.isHidden = true
//        })
//    }
//
//    @IBAction func gestureScreenEdgePan(_ sender: UIScreenEdgePanGestureRecognizer) {
//        // retrieve the current state of the gesture
//        if sender.state == UIGestureRecognizer.State.began {
//
//            // if the user has just started dragging, make sure view for dimming effect is hidden well
//            viewBlack.isHidden = false
//            viewBlack.alpha = 0
//        } else if (sender.state == UIGestureRecognizer.State.changed) {
//
//            // retrieve the amount viewMenu has been dragged
//            let translationX = sender.translation(in: sender.view).x
//            if -constraintMenuWidth.constant + translationX > 0 {
//
//                // viewMenu fully dragged out
//                constraintMenuLeft.constant = 0
//                viewBlack.alpha = maxBlackViewAlpha
//            } else if translationX < 0 {
//
//                // viewMenu fully dragged in
//                constraintMenuLeft.constant = -constraintMenuWidth.constant
//                viewBlack.alpha = 0
//            } else {
//
//                // viewMenu is being dragged somewhere between min and max amount
//                constraintMenuLeft.constant = -constraintMenuWidth.constant + translationX
//
//                let ratio = translationX / constraintMenuWidth.constant
//                let alphaValue = ratio * maxBlackViewAlpha
//                viewBlack.alpha = alphaValue
//            }
//        } else {
//
//            // if the menu was dragged less than half of it's width, close it. Otherwise, open it.
//            if constraintMenuLeft.constant < -constraintMenuWidth.constant / 2 {
//                self.hideMenu()
//            } else {
//                self.openMenu()
//            }
//        }
//    }
//
//
//    @IBAction func gestureTap(_ sender: UITapGestureRecognizer) {
//         self.hideMenu()
//    }
//
//    @IBAction func gesturePan(_ sender: UIPanGestureRecognizer) {
//        // retrieve the current state of the gesture
//        if sender.state == UIGestureRecognizer.State.began {
//
//            // no need to do anything
//        } else if sender.state == UIGestureRecognizer.State.changed {
//
//            // retrieve the amount viewMenu has been dragged
//            let translationX = sender.translation(in: sender.view).x
//            if translationX > 0 {
//
//                // viewMenu fully dragged out
//                constraintMenuLeft.constant = 0
//                viewBlack.alpha = maxBlackViewAlpha
//            } else if translationX < -constraintMenuWidth.constant {
//
//                // viewMenu fully dragged in
//                constraintMenuLeft.constant = -constraintMenuWidth.constant
//                viewBlack.alpha = 0
//            } else {
//
//                // it's being dragged somewhere between min and max amount
//                constraintMenuLeft.constant = translationX
//
//                let ratio = (constraintMenuWidth.constant + translationX) / constraintMenuWidth.constant
//                let alphaValue = ratio * maxBlackViewAlpha
//                viewBlack.alpha = alphaValue
//            }
//        } else {
//
//            // if the drag was less than half of it's width, close it. Otherwise, open it.
//            if constraintMenuLeft.constant < -constraintMenuWidth.constant / 2 {
//                self.hideMenu()
//            } else {
//                self.openMenu()
//            }
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
