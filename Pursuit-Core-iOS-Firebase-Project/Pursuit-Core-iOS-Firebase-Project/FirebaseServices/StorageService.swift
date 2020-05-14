//
//  StorageService.swift
//  Pursuit-Core-iOS-Firebase-Project
//
//  Created by Bienbenido Angeles on 5/14/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
  
  private let storageRef = Storage.storage().reference()
  
  private init() {}
  static let shared = StorageService()
  
  public func uploadPhoto(userId: String? = nil, postId: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) -> ()) {
    
    guard let imageData = image.jpegData(compressionQuality: 1.0) else {
      return
    }
    
    var photoReference: StorageReference! // nil
    
    if let userId = userId { // coming from ProfileViewController
      photoReference = storageRef.child("UserProfilePhotos/\(userId).jpg")
    } else if let postId = postId { // coming from AddPostsVC
      photoReference = storageRef.child("IgPhotos/\(postId).jpg")
    }
    
    // configure metatdata for the object being uploaded
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpg" // MIME type
    
    let _ = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
      if let error = error {
        completion(.failure(error))
      } else if let _ = metadata {
        photoReference.downloadURL { (url, error) in
          if let error = error {
            completion(.failure(error))
          } else if let url = url {
            completion(.success(url))
          }
        }
      }
    }
    
  }
}
