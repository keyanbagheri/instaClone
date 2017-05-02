//
//  FacebookLogInViewController.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 17/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase


class FacebookLogInViewController: UIViewController, FBSDKLoginButtonDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 190, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self

    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("did logout from FB")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        print("successfully logged")
    }

    @IBAction func signInButton(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }

}
