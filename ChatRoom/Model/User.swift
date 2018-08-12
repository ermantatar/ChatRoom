//
//  User.swift
//  ChatRoom
//
//  Created by Erman Sahin Tatar on 8/12/18.
//  Copyright © 2018 Erman Sahin Tatar. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var email: String?
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}