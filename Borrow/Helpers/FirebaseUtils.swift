//
//  FirebaseUtils.swift
//  Borrow
//
//  Created by jackie on 4/18/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

var user = Auth.auth().currentUser

let storage = Storage.storage()
let storageRef = storage.reference()

var databaseRef = Database.database().reference()
