//
//  IgPost.swift
//  Pursuit-Core-iOS-Firebase-Project
//
//  Created by Bienbenido Angeles on 5/14/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation

struct IgPost {
    let username: String
    let userId: String
    let photoURL: String
    let creationDate: String
    let postId: String
}
extension IgPost {
    init(_ dictionary: [String : Any]) {
        self.username = dictionary["username"] as? String ?? "N/A"
        self.userId = dictionary["userId"] as? String ?? "N/A"
        self.photoURL = dictionary["photoURL"] as? String ?? "N/A"
        self.creationDate = dictionary["creationDate"] as? String ?? "N/A"
        self.postId = dictionary["postId"] as? String ?? "N/A"
    }
}
