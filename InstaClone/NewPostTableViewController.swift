//
//  NewPostTableViewController.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 19/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit

class NewPostTableViewController: UITableViewController {


    @IBAction func sharePost(_ sender: Any) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //It will show the status bar again after dismiss
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backAction))
    }
    
    func backAction(){
        dismiss(animated: true, completion: nil)
    }

    func handleShare(){
        //sharePost()
    }
    func handleBack(){
        
    }

}
