//
//  ImageUploadViewController.swift
//  Pursuit-Core-iOS-Firebase-Project
//
//  Created by Bienbenido Angeles on 5/14/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ImageUploadViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var camButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIButton!
    
    private let db = DatabaseService.shared
    private let storageService = StorageService.shared

    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    private var selectedImage: UIImage? {
        didSet{
            DispatchQueue.main.async {
                self.postImageView.image = self.selectedImage
                self.isPostButtonEnabled()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isPostButtonEnabled()
    }
    
    private func isPostButtonEnabled(){
        if postImageView.image == nil {
            postButton.isEnabled = false
        } else {
            postButton.isEnabled = true
        }
    }
    
    @IBAction func camButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Select a photo from: ", message: nil, preferredStyle: .actionSheet)
        let camButtonOptionPressed = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.showImageController(isCameraSelected: true)
        }
        let galleryOptionPressed = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.showImageController(isCameraSelected: false)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(camButtonOptionPressed)
        }
        
        alertController.addAction(galleryOptionPressed)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    private func showImageController(isCameraSelected: Bool) {
        // source type default will be photo library
        imagePickerController.sourceType = .photoLibrary
        
        if isCameraSelected{
            imagePickerController.sourceType = .camera
        }
        present(imagePickerController, animated: true)
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser, let selectedPhoto = selectedImage, let userName = user.displayName else {
            showAlert(title: "Unable to post", message: "Please enter a user display name onto your profile")
            return
        }
        
        let resizedImg =  selectedPhoto.resizeImage(width: postImageView.bounds.width, height: postImageView.bounds.height)
        
        let postId = UUID().uuidString
        
        
        storageService.uploadPhoto(postId: postId, image: resizedImg) { [weak self](result) in
            switch result{
            case .failure(let error):
                self?.showAlert(title: "Error uploading photo", message: "error: \(error.localizedDescription)")
            case .success(let url):
                self?.showAlert(title: "Successfully uploaded photo", message: nil)
                let photo = IgPost(username: userName, userId: user.uid, photoURL: url.absoluteString, creationDate: Date().dateString(), postId: postId)
                self?.createPost(given: photo)
            }
        }
        
    }
    
    private func createPost(given post: IgPost){
        db.createPost(post: post) {[weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed to create post", message: "error: \(error.localizedDescription)")
                }
            case .success:
                self?.showAlert(title: "Post successfull", message: nil)
                self?.selectedImage = nil
                self?.isPostButtonEnabled()
            }
        }
    }
    
}

extension ImageUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //guarding against optional image user selected
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        selectedImage = image
        dismiss(animated: true)
    }
    
}
