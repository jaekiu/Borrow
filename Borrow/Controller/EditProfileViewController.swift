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
                $0.placeholder = "Username"
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
