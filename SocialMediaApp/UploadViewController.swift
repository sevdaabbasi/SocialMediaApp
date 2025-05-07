//
//  UploadViewController.swift
//  SocialMediaApp
//
//  Created by Sevda Abbasi on 5.05.2025.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    // MARK: - Properties
    private let storage = Storage.storage()
    private let firestore = Firestore.firestore()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
    }
    
    // MARK: - Setup Methods
    private func setupImageView() {
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - Actions
    @objc private func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        guard let image = imageView.image,
              let imageData = image.jpegData(compressionQuality: 0.5),
              let comment = commentText.text, !comment.isEmpty else {
            showAlert(title: "Error", message: "Please select an image and add a comment")
            return
        }
        
        uploadImage(imageData: imageData, comment: comment)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true)
    }
    
    // MARK: - Firebase Methods
    private func uploadImage(imageData: Data, comment: String) {
        let uuid = UUID().uuidString
        let imageReference = storage.reference().child("media/\(uuid).jpg")
        
        imageReference.putData(imageData, metadata: nil) { [weak self] (metadata, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            self.savePostToFirestore(imageReference: imageReference, comment: comment)
        }
    }
    
    private func savePostToFirestore(imageReference: StorageReference, comment: String) {
        imageReference.downloadURL { [weak self] (url, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            guard let imageUrl = url?.absoluteString,
                  let currentUser = Auth.auth().currentUser else {
                self.showAlert(title: "Error", message: "Failed to get image URL or user information")
                return
            }
            
            let postData: [String: Any] = [
                "imageUrl": imageUrl,
                "postedBy": currentUser.email ?? "",
                "postComment": comment,
                "date": FieldValue.serverTimestamp(),
                "likes": 0
            ]
            
            self.firestore.collection("Posts").addDocument(data: postData) { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                
                self.resetUI()
            }
        }
    }
    
    // MARK: - Helper Methods
    private func resetUI() {
        imageView.image = UIImage(named: "select.png")
        commentText.text = ""
        tabBarController?.selectedIndex = 0
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
