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

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInText: UILabel!
    @IBOutlet weak var rectangleImgView: UIImageView!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signInText.addBottomBorder(borderColor: UIColor(red: 100/255.0, green: 196/255.0, blue: 226/255.0, alpha: 1), borderHeight: 3.0)
        signInButton.setRounded()
        self.emailTextField.delegate = self
        self.passTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        drawRectangleBg()
        
    }
    
    /** Dismisses the keyboard upon pressing return. */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            // background rectangle
            ctx.cgContext.setFillColor(UIColor(red: 100/255.0, green: 196/255.0, blue: 226/255.0, alpha: 1).cgColor)
            
            let rectangle = CGRect(x: 0, y: 0, width: 50, height: 50)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.setLineWidth(0)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            // ellipse 1
            ctx.cgContext.setFillColor(UIColor(red: 124/255.0, green: 212/255.0, blue: 240/255.0, alpha: 0.68).cgColor)
            
            let ellipseUno = CGRect(x: -20, y: -5, width: 55, height: 65)
            ctx.cgContext.addEllipse(in: ellipseUno)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            // ellipse 2
            ctx.cgContext.setFillColor(UIColor(red: 124/255.0, green: 228/255.0, blue: 235/255.0, alpha: 0.29).cgColor)
            
            let ellipseDos = CGRect(x: 17, y: -7, width: 80, height: 40)
            ctx.cgContext.addEllipse(in: ellipseDos)
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
