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
  static let igPostCollection = "posts"
  
  private let db = Firestore.firestore()
  
  private init() {}
  static let shared = DatabaseService()
  
    public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>) -> ()) {
    guard let email = authDataResult.user.email else {
      return
    }
    db.collection(DatabaseService.usersCollection)
      .document(authDataResult.user.uid)
      .setData(["email" : email,
                "createdDate": Timestamp(date: Date()),
                "userId": authDataResult.user.uid,
      ]) { (error) in
      
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    }
  }
    
    public func createPost(post: IgPost, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser, let displayName = user.displayName else { return }
        let documentRef = db.collection(DatabaseService.igPostCollection).document()
        db.collection(DatabaseService.igPostCollection).document(documentRef.documentID).setData([
            "username" : displayName,
            "userId": user.uid,
            "postId": post.postId,
            "photoURL": post.photoURL,
            "creationDate": post.creationDate
        ]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        
    }
}
