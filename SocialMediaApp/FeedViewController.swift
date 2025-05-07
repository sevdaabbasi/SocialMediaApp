//
//  FeedViewController.swift
//  SocialMediaApp
//
//  Created by Sevda Abbasi on 5.05.2025.
//


import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var userEmailArray = [String]()
    private var userCommentArray = [String]()
    private var likeArray = [Int]()
    private var imageBase64Array = [String]()
    private var documentIdArray = [String]()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchPostsFromFirestore()
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Firebase Methods
    private func fetchPostsFromFirestore() {
        let firestore = Firestore.firestore()
        
        firestore.collection("Posts")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching posts: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "Failed to fetch posts: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot, !snapshot.isEmpty else {
                    print("No posts found")
                    return
                }
                
                self.clearArrays()
                
                for document in snapshot.documents {
                    self.processDocument(document)
                }
                
                self.tableView.reloadData()
            }
    }
    
    private func clearArrays() {
        userEmailArray.removeAll(keepingCapacity: false)
        userCommentArray.removeAll(keepingCapacity: false)
        likeArray.removeAll(keepingCapacity: false)
        imageBase64Array.removeAll(keepingCapacity: false)
        documentIdArray.removeAll(keepingCapacity: false)
    }
    
    private func processDocument(_ document: QueryDocumentSnapshot) {
        let documentID = document.documentID
        documentIdArray.append(documentID)
        
        if let postedBy = document.get("postedBy") as? String {
            userEmailArray.append(postedBy)
        }
        
        
        
        if let postComment = document.get("postComment") as? String {
            userCommentArray.append(postComment)
        }
        
        if let likes = document.get("likes") as? Int {
            likeArray.append(likes)
        }
        
        if let imageUrl = document.get("imageUrl") as? String {
            imageBase64Array.append(imageUrl) // istersen burada imageUrlArray'e ekle
        }
        
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FeedCell else {
            return UITableViewCell()
        }
        
        configureCell(cell, at: indexPath)
        return cell
    }
    
  
    
    private func configureCell(_ cell: FeedCell, at indexPath: IndexPath) {
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        
        // Firestore'dan imageUrl arrayini almayı unutma!
         let imageUrl = imageBase64Array[indexPath.row] // artık bu imageUrl olacak
         
         if let url = URL(string: imageUrl) {
         cell.userImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "select.png"))
         } else {
         cell.userImageView.image = UIImage(named: "select.png")
         }
        }
         
    }



