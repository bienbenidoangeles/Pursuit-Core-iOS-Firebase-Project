//
//  DatabaseService.swift
//  Pursuit-Core-iOS-Firebase-Project
//
//  Created by Bienbenido Angeles on 5/14/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation

import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
  
  static let usersCollection = "users"
  static let favoritesTickets = "favoritedTickets"
    static let favoriteMuseum = "favoritedMuseum"
  
  private let db = Firestore.firestore()
  
  private init() {}
  static let shared = DatabaseService()
  
    public func createDatabaseUser(authDataResult: AuthDataResult, userExp: UserExperience, completion: @escaping (Result<Bool, Error>) -> ()) {
    guard let email = authDataResult.user.email else {
      return
    }
    db.collection(DatabaseService.usersCollection)
      .document(authDataResult.user.uid)
      .setData(["email" : email,
                "createdDate": Timestamp(date: Date()),
                "userId": authDataResult.user.uid,
                "userExp": userExp.rawValue ]) { (error) in
      
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    }
  }
}
