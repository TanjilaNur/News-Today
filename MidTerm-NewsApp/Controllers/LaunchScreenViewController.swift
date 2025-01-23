//
//  LaunchScreenViewController.swift
//  MidTerm-NewsApp
//
//  Created by BJIT on 18/1/23.


import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Go to Home View after 3sec
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            self.performSegue(withIdentifier: Constants.goToHome, sender: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.viewControllers.removeAll(where: { viewController in
            viewController == self
                })
    }
}
