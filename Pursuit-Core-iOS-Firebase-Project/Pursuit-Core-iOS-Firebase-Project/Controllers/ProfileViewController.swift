//
//  ProfileViewController.swift
//  Pursuit-Core-iOS-Firebase-Project
//
//  Created by Bienbenido Angeles on 5/14/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var editProfileImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var editDisplayName: UIButton!
    
    private let authService = AuthenticationSession.shared
    private let db = DatabaseService.shared
    private let storageService = StorageService.shared
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }
    
    private func loadData(){
        guard let user = Auth.auth().currentUser, let url = user.photoURL, let name = user.displayName else {
            return
        }
        profileImageView.kf.setImage(with: url)
        displayNameLabel.text = name
    }
    
    
    @IBAction func profileIVButtonPressed(_ sender: UIButton) {
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
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Edit Username",message: nil, preferredStyle: .alert)
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         let okAction = UIAlertAction(title: "OK", style: .default) { action in
            guard let textField = alertController.textFields?.first, let text = textField.text, !text.isEmpty else {
                 return
             }
             
            self.authService.updateExistingUser(displayName: text, photoURL: nil, completion: { [weak self](result) in
                switch result {
                case .failure(let error):
                    self?.showAlert(title: "Error updating user", message: "\(error.localizedDescription)")
                case .success:
                    self?.displayNameLabel.text = text
                }
            })
         }
         
         alertController.addTextField { textField in
             textField.delegate = self
         }
         alertController.addAction(okAction)
         alertController.addAction(cancelAction)
         
         present(alertController, animated: true)
    }
    
    

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //guarding against optional image user selected
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let user = Auth.auth().currentUser else {
            return
        }
        
        storageService.uploadPhoto(userId: user.uid, image: image) { (result) in
            switch result {
            case .failure(let error):
                self.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
            case .success(let url):
                self.authService.updateExistingUser(photoURL: url, completion: { [weak self](result) in
                    switch result {
                    case .failure(let error):
                        self?.showAlert(title: "Error updating user", message: "\(error.localizedDescription)")
                    case .success:
                        self?.profileImageView.image = image
                        picker.dismiss(animated: true)
                    }
                })
            }
        }
        dismiss(animated: true)
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
