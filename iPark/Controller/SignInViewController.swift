//
// SignInViewController.swift
//  iPark
//
//  Created by Sergio Nunez on 1/26/19.
//  Copyright © 2019 Sergio Nunez. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

///////Function to hide keyboard on tap /////////
extension UIViewController {
    
    func HideKeyboard() {
        
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self , action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(Tap)
    }
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
  
    // Outlets
    @IBOutlet weak var EmailSignIn: UITextField!
    @IBOutlet weak var PasswordSignIn: UITextField!

    // Variables
    
    
    // Constants
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.HideKeyboard()
        
    }
    
    
    func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                print("User Signed In")
                //
                self.performSegue(withIdentifier: "SignInToMap", sender: self)
                
            } else {
                let alert = UIAlertController(title: "Something's Wrong!", message: "Please check your credetials or touch on SignUp to register", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    print ("Success")
                }
                
                alert.addAction(action)
                
                self.present(alert,animated: true, completion: nil)
            }
            
        }
    }
    
    
    //Actions
    @IBAction func SignIn(_ sender: Any) {
    
        signInUser(email: EmailSignIn.text!, password: PasswordSignIn.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
