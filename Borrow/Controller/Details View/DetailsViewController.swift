//
//  DetailsViewController.swift
//  Borrow
//
//  Created by jackie on 4/17/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var transactionID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Details"
        navigationController?.navigationBar.barTintColor = UIColor(red: 100/255.0, green: 196/255.0, blue: 226/255.0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        navigationController?.navigationBar.tintColor = .white

    }
    




}
