//
//  FeedCell.swift
//  SocialMediaApp
//
//  Created by Sevda Abbasi on 6.05.2025.
//


import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class FeedCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    //eqweqw
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        // Add any additional UI setup here
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
    }
    
    // MARK: - Actions
    @IBAction func likeButtonClicked(_ sender: Any) {
        guard let documentId = documentIdLabel.text,
              let currentLikes = Int(likeLabel.text ?? "0") else { return }
        
        updateLikeCount(documentId: documentId, newLikeCount: currentLikes + 1)
    }
    
    // MARK: - Firebase Methods
    private func updateLikeCount(documentId: String, newLikeCount: Int) {
        let firestore = Firestore.firestore()
        let likeData = ["likes": newLikeCount] as [String: Any]
        
        firestore.collection("Posts")
            .document(documentId)
            .setData(likeData, merge: true) { [weak self] error in
                if let error = error {
                    print("Error updating like count: \(error.localizedDescription)")
                }
            }
    }
}

