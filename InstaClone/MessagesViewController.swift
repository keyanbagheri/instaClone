//
//  MessagesViewController.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 16/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
// TEST VIEW CONTROLLER
// TEST VIEW CONTROLLER
// TEST VIEW CONTROLLER

import UIKit

class MessagesViewController: UIViewController {

    @IBOutlet weak var shitLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }

}
// TEST VIEW CONTROLLER
// TEST VIEW CONTROLLER
// TEST VIEW CONTROLLER
