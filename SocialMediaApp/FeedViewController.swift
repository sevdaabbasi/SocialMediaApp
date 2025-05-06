//
//  FeedViewController.swift
//  SocialMediaApp
//
//  Created by Sevda Abbasi on 5.05.2025.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", )
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



/*
 import UIKit
 import Firebase

 class FeedCell: UITableViewCell {

     @IBOutlet weak var userEmailLabel: UILabel!
     
     @IBOutlet weak var commentLabel: UILabel!
     
     @IBOutlet weak var userImageView: UIImageView!
     
     @IBOutlet weak var likeLabel: UILabel!
     
     @IBOutlet weak var documentIdLabel: UILabel!
     
     override func awakeFromNib() {
         super.awakeFromNib()
         // Initialization code
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

         // Configure the view for the selected state
     }
     
     @IBAction func likeButtonClicked(_ sender: Any) {
         
         let fireStoreDatabase = Firestore.firestore()
         
         if let likeCount = Int(likeLabel.text!) {
             
             let likeStore = ["likes" : likeCount + 1] as [String : Any]
             
             fireStoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)

         }
         
         
     }
     
 }


*/
