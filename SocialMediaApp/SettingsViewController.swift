//
//  SettingsViewController.swift
//  SocialMediaApp
//
//  Created by Sevda Abbasi on 5.05.2025.
//
import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        // Add any additional UI setup here
    }
    
    // MARK: - Actions
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigateToLoginScreen()
        } catch {
            showAlert(title: "Error", message: "Failed to sign out: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Navigation
    private func navigateToLoginScreen() {
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
