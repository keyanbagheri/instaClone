//
//  LogInViewController.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 16/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        handleLogin()
        print("login sucessfull")
    }
    
    var messagesController: MessagesViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleLogin()
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                return
            }
           self.goToNextVC()
        })
    }
    func goToNextVC(){
        let initController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "MessagesViewController")
        present(initController, animated: true, completion: nil)
    }
    
    
}
