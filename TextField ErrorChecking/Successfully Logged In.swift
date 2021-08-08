//
//  Successfully Logged In.swift
//  TextField ErrorChecking
//
//  Created by Jacob Trentini on 8/7/21.
//

import UIKit

class SuccessfullyLoggedIn: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    public var signedInUser = UserProfile()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameLabel.text = "Welcome to your new account, \(signedInUser.username)"
        emailLabel.text = "Email: \(signedInUser.email)"
        passwordLabel.text = "Password: \(signedInUser.password)"
    }
}
