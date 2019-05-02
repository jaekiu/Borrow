//
//  PopUpViewController.swift
//  Borrow
//
//  Created by jackie on 5/1/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var requestTransButton: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        profilePic.setRounded()
        requestTransButton.setRounded()
        nameLabel.text = user.getName()
        usernameLabel.text = "@\(user.getUsername())"
        let id = user.getUid()
        let placeholderImageUser = UIImage(named: "default")
        let imgRef = storageRef.child("users").child("\(id ?? "").jpg")
        profilePic.sd_setImage(with: imgRef, placeholderImage: placeholderImageUser)
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        self.removeAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }

    @IBAction func goToAddTransaction(_ sender: Any) {
        performSegue(withIdentifier: "popUpToAddSegue", sender: nil)
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
