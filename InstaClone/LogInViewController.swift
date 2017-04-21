//
//  LogInViewController.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 16/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit
import Firebase


class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var wholeView: UIView!

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        handleLogin()
        print("login sucessfull")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wholeView.isHidden = true
        let tf = UITextField()
        tf.autocapitalizationType = .none
        emailTextField.delegate = self
        passwordTextField.delegate = self
        handleLogin()
        let when = DispatchTime.now() + 0.0000000000000000000000000001 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.checkIfLoggedIn()
        }
        
    }
 
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }

        if email == "" || password == ""{
            warningPopUp(withTitle: "Input Error", withMessage: "Email or Password Can't Be Empty")
            return
        }
        
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.warningPopUp(withTitle: "Input Error", withMessage: "Email or Password is incorrect")
                return
            }
            self.goToNextVC()
            self.clearTextFieldText()
        })
    }
    func clearTextFieldText(){
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func checkIfLoggedIn () {
        if (FIRAuth.auth()?.currentUser) != nil {
            print("Some user already logged in")
            goToNextVC()
        } else {
            self.wholeView.isHidden = false
        }
    }
    
    func goToNextVC(){
        let initController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Main.storyboard")
        present(initController, animated: true, completion: nil)
    }
    
    
}
