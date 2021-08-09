//
//  SignUp.swift
//  AuthenticationCheck
//
//  Created by Jacob Trentini on 8/7/21.
//

import UIKit

class UserProfile {
    var username = String()
    var email = String()
    var password = String()
}

class SignUp: UIViewController {
    private let checker = AuthenticationCheck()
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func createAnAccountAction(_ sender: Any) {
        checker.evaluateWithShake(usernameField: usernameField, emailField: emailField, passwordField: passwordField, confirmPasswordField: confirmPasswordField, currentViewController: self) {
            
            print("Perfect credentials entered!")
            view.endEditing(true)
            errorLabel.isHidden = true
            errorLabel.text?.removeAll()

            let successVC = storyboard?.instantiateViewController(withIdentifier: "SuccessfullyLoggedIn") as! SuccessfullyLoggedIn
            navigationController?.pushViewController(successVC, animated: true)
            let signedInUser = UserProfile()
            signedInUser.username = usernameField.text!
            signedInUser.email = emailField.text!
            signedInUser.password = passwordField.text!
            successVC.signedInUser = signedInUser
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        checker.passwordMaximumLength
    }
}



//        do {
//            try checker.evaluate(username: usernameField.text!, email: emailField.text!, password: passwordField.text!, confirmPassword: confirmPasswordField.text!)
//            print("Perfect credentials entered!")
//            view.endEditing(true)
//            errorLabel.isHidden = true
//            errorLabel.text?.removeAll()
//
//            let successVC = storyboard?.instantiateViewController(withIdentifier: "SuccessfullyLoggedIn") as! SuccessfullyLoggedIn
//            navigationController?.pushViewController(successVC, animated: true)
//            let signedInUser = UserProfile()
//            signedInUser.username = usernameField.text!
//            signedInUser.email = emailField.text!
//            signedInUser.password = passwordField.text!
//            successVC.signedInUser = signedInUser
//        }
//
//        // General Errors
//         catch AuthenticationCheckGeneralError.passwordContainsEmail {
//             showAlert(message: "Password contains email", textFields: [usernameField, passwordField])
//        } catch AuthenticationCheckGeneralError.passwordContainsUsername {
//            showAlert(message: "Password contains username", textFields: [passwordField, usernameField])
//        } catch AuthenticationCheckGeneralError.emailContainsPassword {
//            showAlert(message: "Email contains password", textFields: [emailField, passwordField])
//        } catch AuthenticationCheckGeneralError.usernameContainsEmail {
//            showAlert(message: "Username contains email", textFields: [usernameField, emailField])
//        } catch AuthenticationCheckGeneralError.usernameContainsPassword {
//            showAlert(message: "Username contains password", textFields: [usernameField, passwordField])
//        } catch AuthenticationCheckGeneralError.passwordDoesNotMatchConfirmPassword {
//            showAlert(message: "Password does not match Confirm Password", textFields: [passwordField, confirmPasswordField])
//        }
//
//        // Username Error
//         catch AuthenticationCheckUsernameError.empty {
//            showAlert(message: "Please enter a username", textFields: [usernameField])
//             usernameField.shake(baseColor: UIColor.systemPink.cgColor, numberOfShakes: 3, revert: true)
//        }
//
//        // Email Errors
//         catch AuthenticationCheckEmailError.empty {
//            showAlert(message: "Please enter an email", textFields: [emailField])
//         } catch AuthenticationCheckEmailError.invalidEmail {
//            showAlert(message: "Please enter a valid email", textFields: [emailField])
//        }
//
//        // Password Errors
//         catch AuthenticationCheckPasswordError.empty {
//           showAlert(message: "Please enter a password", textFields: [passwordField])
//        } catch AuthenticationCheckPasswordError.passwordContainsNoNumbers {
//            showAlert(message: "At least 1 number is required in the password", textFields: [passwordField])
//        } catch AuthenticationCheckPasswordError.passwordContainsNoLetters {
//            showAlert(message: "At Least 1 letter is required in the password", textFields: [passwordField])
//        } catch AuthenticationCheckPasswordError.passwordTooLong {
//            showAlert(message: "The password cannot exceed \(checker.passwordMinimumLength + 1) characters in length", textFields: [passwordField])
//        } catch AuthenticationCheckPasswordError.passwordTooShort {
//            showAlert(message: "The password must include \(checker.passwordMinimumLength) characters", textFields: [passwordField])
//        } catch {
//            fatalError("Error uncaught = \(error.localizedDescription)")
//        }
//    }
