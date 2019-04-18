//
//  Utils.swift
//  Borrow
//
//  Created by jackie on 4/17/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
