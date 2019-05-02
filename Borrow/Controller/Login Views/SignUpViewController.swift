//
//  ViewController.swift
//  Borrow
//
//  Created by jackie on 4/10/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    var ref: DatabaseReference!
    
    @IBAction func signInButton(_ sender: UIButton) {
        performSegue(withIdentifier: "performSignIn", sender: sender)
    }
    
    @IBOutlet weak var signUpText: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var rectangleImgView: UIImageView!


    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        signUpText.addBottomBorder(borderColor: UIColor(red: 100/255.0, green: 196/255.0, blue: 226/255.0, alpha: 1), borderHeight: 3.0)
        signUpButton.setRounded()
        
        drawRectangleBg()
        ref = Database.database().reference()
        
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

    func signUpUser(name: String, email: String, username: String, pass: String, confirmPass: String) {
        
        if name == nil || email == nil || username == nil || pass == nil || confirmPass == nil {
            alertNoText()
            return
        } else if name == "" || email == "" || username == "" || pass == "" || confirmPass == "" {
            alertNoText()
            return
        } else if pass != confirmPass {
            alertPassword()
            return
        } else {
            databaseRef.child("usernames/\(username.lowercased())").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists(){
                    self.alertUsername()
                    return
                } else {
                    Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                        if let user = authResult?.user {
                            databaseRef.child("users").child(user.uid).setValue(["name": name, "username": username.lowercased()])
                            // Updates usernames database
                            databaseRef.child("usernames").child(username.lowercased()).setValue(["uid": user.uid, "name": name])
                            self.setDefaultPic(id: user.uid)
                            
                            self.performSegue(withIdentifier: "signUpToFeed", sender: self)
                        } else {
                            self.alertFailedSignUp()
                            return
                        }
                    }
                }
            })
        }
    }

    func setDefaultPic(id: String!){
        let img = UIImage(named: "default")
        let data = img!.jpegData(compressionQuality: 0.8)
        
        let imgRef = storageRef.child("users").child("\(id ?? "").jpg")
        imgRef.putData(data!, metadata: nil){ (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            imgRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        
    }
    
    func alertUsername() {
        let alertController = UIAlertController(title: "Sign Up Failed", message:
            "Username already exists.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertFailedSignUp() {
        let alertController = UIAlertController(title: "Sign Up Failed", message:
            "Sign up failed.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertNoText() {
        let alertController = UIAlertController(title: "Sign Up Failed", message:
            "Please fill out all the fields.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertPassword() {
        let alertController = UIAlertController(title: "Sign Up Failed", message:
            "Passwords do not match.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func clickSignUp(_ sender: Any) {
        signUpUser(name: nameTextField.text!, email: emailTextField.text!, username: usernameTextField.text!, pass: passTextField.text!, confirmPass: confirmPassTextField.text!)
    }
}

extension UILabel {
    
    func addBottomBorder(borderColor: UIColor, borderHeight: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        border.frame = CGRect(x: -10,y: self.frame.size.height - borderHeight + 10, width:self.frame.size.width + 20, height:borderHeight)
        self.layer.addSublayer(border)
    }
    
}
