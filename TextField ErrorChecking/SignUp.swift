//
//  SignUp.swift
//  TextField ErrorChecking
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
    public let checker = UITextFieldAuthenticationCheck()
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func createAnAccountAction(_ sender: Any) {
        do {
            try checker.evaluate(username: usernameField.text!, email: emailField.text!, password: passwordField.text!, confirmPassword: confirmPasswordField.text!)
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

        // General Errors
         catch UITextFieldAuthenticationGeneralError.passwordContainsEmail {
             showAlert(message: "Password contains email", textFields: [usernameField, passwordField])
        } catch UITextFieldAuthenticationGeneralError.passwordContainsUsername {
            showAlert(message: "Password contains username", textFields: [passwordField, usernameField])
        } catch UITextFieldAuthenticationGeneralError.emailContainsPassword {
            showAlert(message: "Email contains password", textFields: [emailField, passwordField])
        } catch UITextFieldAuthenticationGeneralError.usernameContainsEmail {
            showAlert(message: "Username contains email", textFields: [usernameField, emailField])
        } catch UITextFieldAuthenticationGeneralError.usernameContainsPassword {
            showAlert(message: "Username contains password", textFields: [usernameField, passwordField])
        } catch UITextFieldAuthenticationGeneralError.passwordDoesNotMatchConfirmPassword {
            showAlert(message: "Password does not match Confirm Password", textFields: [passwordField, confirmPasswordField])
        }

        // Username Error
         catch UITextFieldAuthenticationUsernameError.empty {
            showAlert(message: "Please enter a username", textFields: [usernameField])
             usernameField.shake(baseColor: UIColor.systemPink.cgColor, numberOfShakes: 3, revert: true)
        }

        // Email Errors
         catch UITextFieldAuthenticationEmailError.empty {
            showAlert(message: "Please enter an email", textFields: [emailField])
        } catch UITextFieldAuthenticationEmailError.invalidEmail {
            showAlert(message: "Please enter a valid email", textFields: [emailField])
        }

        // Password Errors
         catch UITextFieldAuthenticationPasswordError.empty {
           showAlert(message: "Please enter a password", textFields: [passwordField])
        } catch UITextFieldAuthenticationPasswordError.passwordContainsNoNumbers {
            showAlert(message: "At least 1 number is required in the password", textFields: [passwordField])
        } catch UITextFieldAuthenticationPasswordError.passwordContainsNoLetters {
            showAlert(message: "At Least 1 letter is required in the password", textFields: [passwordField])
        } catch UITextFieldAuthenticationPasswordError.passwordContainsMoreCharacterLimit {
            showAlert(message: "The password cannot exceed \(checker.passwordMinimumLength + 1) characters in length", textFields: [passwordField])
        } catch UITextFieldAuthenticationPasswordError.passwordTooShort {
            showAlert(message: "The password must include \(checker.passwordMinimumLength) characters", textFields: [passwordField])
        } catch {
            fatalError("Error uncaught = \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func showAlert(message:String, textFields: [UITextField]) {
        let alert = UIAlertController(title: message, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        errorLabel.isHidden = false
        errorLabel.text = message
        
        for textField in textFields {
            textField.shake(baseColor: UIColor.systemPink.cgColor, numberOfShakes: 3, revert: true)
        }
    }
    
}

