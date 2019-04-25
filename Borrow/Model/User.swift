//
//  User.swift
//  Borrow
//
//  Created by jackie on 4/25/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    /** Represents the uid of the user. */
    var uid: String
    
    /** Represents the name of the user. */
    var name: String
    
    /** Represents the username of the user. */
    var username: String
    
    /** Represents the profile pic of the user. */
    var profilePic = UIImage(named: "default")
    
    init(uid: String, name: String, username: String) {
        self.uid = uid
        self.name = name
        self.username = username
    }
    
    func getUid() -> String {
        return uid
    }
    
    func getName() -> String {
        return name
    }
    
    func getUsername() -> String {
        return username
    }
    
    func getProfilePic() -> UIImage {
        return profilePic!
    }

}
