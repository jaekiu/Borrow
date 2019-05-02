//
//  EditProfileViewController.swift
//  Borrow
//
//  Created by jackie on 5/2/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit
import Eureka
import ImageRow

class EditProfileViewController: FormViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = nil
        navigationController?.navigationBar.tintColor = nil
        let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView
        if statusBar?.responds(to: #selector(setter: UIView.backgroundColor)) ?? false {
            statusBar?.backgroundColor = nil
        }
        
        
        // Eureka Form
        form
            +++ Section("Name")
            <<< TextAreaRow("name"){
                $0.placeholder = "Name"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 23)
            }
            +++ Section("Profile Picture") {
                $0.tag = "profilepic"
            }
            <<< ImageRow("img") {
                $0.title = "Attachment"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                $0.clearAction = .yes(style: .destructive)
        }
    }
    
    @IBAction func saveProfileEdits(_ sender: Any) {
        finishTransaction()
        performSegue(withIdentifier: "editProfileToFeedSegue", sender: sender)
        
    }
    func finishTransaction() {
        // Retrieves all the values
        let valuesDictionary = form.values()
        
        // Retrieves the other party
        let name = valuesDictionary["name"] as? String
        if (name != nil && name != "") {
            databaseRef.child("users").child(user!.uid).updateChildValues(["name": name!])
        }
        
        if let image = valuesDictionary["img"] as? UIImage {
            self.uploadImagePic(img: image)
        }

    }
    
    func uploadImagePic(img: UIImage){
        let data = img.jpegData(compressionQuality: 0.8)
        
        let imgRef = storageRef.child("users").child("\(user?.uid ?? "").jpg")
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
    
    func alertBadName() {
        let alertController = UIAlertController(title: "Error!", message:
            "Please enter a valid name.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alertController, animated: true, completion: nil)
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
