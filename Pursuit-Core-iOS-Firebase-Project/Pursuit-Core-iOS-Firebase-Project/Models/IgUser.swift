//
//  IgUser.swift
//  Pursuit-Core-iOS-Firebase-Project
//
//  Created by Bienbenido Angeles on 5/14/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation

struct IgUser {
    let userId: String
    let userEmail: String
}

extension IgUser {
    init(_ dictionary: [String : Any]) {
        self.userId = dictionary["userId"] as? String ?? "N/A"
        self.userEmail = dictionary["userEmail"] as? String ?? "N/A"
    }
}
