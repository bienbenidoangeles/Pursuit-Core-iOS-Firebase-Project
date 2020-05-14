//
//  AuthenticationSession.swift
//  Pursuit-Core-iOS-Firebase-Project
//
//  Created by Bienbenido Angeles on 5/14/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthenticationSession {
  
  private init() {}
  static let shared = AuthenticationSession()
  
  public func createNewUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
    Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
      if let error = error {
        completion(.failure(error))
      } else if let authDataResult = authDataResult {
        completion(.success(authDataResult))
      }
    }
  }
  
  public func signExistingUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
    Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
      if let error = error {
        completion(.failure(error))
      } else if let authDataResult = authDataResult {
        completion(.success(authDataResult))
      }
    }
  }
    
    public func updateExistingUser(displayName: String? = nil, photoURL: URL? = nil, completion: @escaping (Result<Bool, Error>)->()){
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let request = user.createProfileChangeRequest()
        if let name = displayName {
            request.displayName = name
        }
        if let photoURL = photoURL{
            request.photoURL = photoURL
        }
        request.commitChanges { (error) in
            if let error = error{
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
  
}
