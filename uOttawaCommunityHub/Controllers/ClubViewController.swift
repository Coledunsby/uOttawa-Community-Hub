//
//  ClubViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-28.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class ClubViewController: UIViewController {

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonTapped(button: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }

}
