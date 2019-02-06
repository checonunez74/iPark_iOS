//
//  RegisterViewController.swift
//  iPark
//
//  Created by Sergio Nunez on 1/28/19.
//  Copyright © 2019 Sergio Nunez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class RegisterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
  
    //Outlets
    ///////PickerView Outlests///////////
    @IBOutlet weak var SignUpLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    ///////Register Form outlets////////
    
    @IBOutlet weak var NameOu: UITextField!
    @IBOutlet weak var LastNameOu: UITextField!
    @IBOutlet weak var EmailOu: UITextField!
    @IBOutlet weak var PasswordOu: UITextField!
    @IBOutlet weak var PasswordConfOu: UITextField!
    @IBOutlet weak var StudentIDOu: UITextField!
    
    
    //Constants
    let zones = ["Zone 1", "Zone 2", "Zone 3"]

    
    
    // Do any additional setup after loading the view.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return zones[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return zones.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SignUpLabel.text = zones[row]
    }
    
    func createUser(email:String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { ( result, error) in
            if error == nil {
                // User created
                print("User Created")
                // SignIn User
                 self.performSegue(withIdentifier: "goToMap", sender: self)
            }else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    //Actons

    @IBAction func registerPressed(_ sender: Any) {

        Auth.auth().createUser(withEmail: EmailOu.text!, password: PasswordOu.text!) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                let alert = UIAlertController(title: "Something's Wrong!", message: "Please try again later", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    print ("Success")
                }
                
                alert.addAction(action)
                
                self.present(alert,animated: true, completion: nil)
            }
            else {
                let ref = Database.database().reference()
                let usersReference = ref.child("users")
               // print(usersReference.description())
                
               ////////new way to get uid from Firebase without using FIRUser////////
                let user = Auth.auth().currentUser
                if let user = user {
                    // The user's ID, unique to the Firebase project.
                    // Do NOT use this value to authenticate with your backend server,
                    // if you have one. Use getTokenWithCompletion:completion: instead.
                    let uid = user.uid
                   
                   // ...
                   let newUserReference = usersReference.child(uid)
                    newUserReference.setValue(["username": self.NameOu, "email": self.EmailOu])
                }
                
                print("Registration Succesful!")
                self.performSegue(withIdentifier: "signUpToMap", sender: self)
            }
        }
        
        
    }
    
    //////Code for the scroll view item/////
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                //////Code for the scroll view item/////
                NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
                NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
                self.HideKeyboard()
        
    }
    
    
    ////function to make keyboard autoadjust ////////
    @objc func keyboard(notification: Notification)  {
        
        let userInfo = notification .userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
        }else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        
    }
    
    ///Function for keyboard hide on return/////////
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    

}

