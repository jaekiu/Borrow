//
//  SignInViewController.swift
//  Borrow
//
//  Created by jackie on 4/10/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInText: UILabel!
    @IBOutlet weak var rectangleImgView: UIImageView!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signInText.addBottomBorder(borderColor: UIColor(red: 100/255.0, green: 196/255.0, blue: 226/255.0, alpha: 1), borderHeight: 3.0)
        signInButton.layer.cornerRadius = 18
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor(red: 100/255.0, green: 196/255.0, blue: 226/255.0, alpha: 1).cgColor
        
        drawRectangleBg()
        checkForAutoLogin()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func drawRectangleBg() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50
            , height: 50))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor(red: 100/255.0, green: 196/255.0, blue: 226/255.0, alpha: 1).cgColor)
            
            let rectangle = CGRect(x: 0, y: 0, width: 50, height: 50)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.setLineWidth(0)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            
        }
        
        rectangleImgView.image = img
    }

    func signInUser(email: String, pass: String) {
        
        if email == "" || pass == "" {
            alertNoText()
            return
        } else {
            Auth.auth().signIn(withEmail: email, password: pass) { [weak self] user, error in
                guard let strongSelf = self else { return }
                if let error = error {
                    strongSelf.alertFailedSignIn()
                    return
                }
                strongSelf.goToFeed()
            }
        }
    }
    
    func checkForAutoLogin() {
        if Auth.auth().currentUser != nil {
            // User is logged in
            goToFeed()
        } else {
            // User is not logged in
        }
    }
    
    func goToFeed() {
        performSegue(withIdentifier: "signInToFeed", sender: self)
    }
    
    // ALERTS --------
    
    func alertFailedSignIn() {
        let alertController = UIAlertController(title: "Sign In Failed", message:
            "Incorrect email or password.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertNoText() {
        let alertController = UIAlertController(title: "Sign In Failed", message:
            "Please fill out all the fields.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    

    @IBAction func signInButton(_ sender: UIButton) {
        signInUser(email: emailTextField.text!, pass: passTextField.text!)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "performSignUp", sender: sender)
    }
    
}
