//
//  SignUp.swift
//  TextField ErrorChecking
//
//  Created by Jacob Trentini on 8/7/21.
//

import UIKit

class SignUp: UIViewController {
    public let checker = UITextFieldAuthenticationCheck()
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBAction func createAnAccountAction(_ sender: Any) {
        do {
            try checker.evaluate(username: usernameField.text!, email: emailField.text!, password: passwordField.text!, confirmPassword: confirmPasswordField.text!)
        }

        // General Errors
         catch UITextFieldAuthenticationGeneralError.passwordContainsEmail {
            print("Password contains email")
        } catch UITextFieldAuthenticationGeneralError.passwordContainsUsername {
            print("Password contains username")
        } catch UITextFieldAuthenticationGeneralError.emailContainsPassword {
            print("Email contains password")
        } catch UITextFieldAuthenticationGeneralError.emailContainsUsername {
            print("Email contains username")
        } catch UITextFieldAuthenticationGeneralError.usernameContainsEmail {
            print("Username contains email")
        } catch UITextFieldAuthenticationGeneralError.usernameContainsPassword {
            print("Username contains password")
        } catch UITextFieldAuthenticationGeneralError.passwordDoesNotMatchConfirmPassword {
            print("Password does not match Confirm Password")
        }

        // Username Error
         catch UITextFieldAuthenticationUsernameError.empty {
            print("Please enter a username")
        }

        // Email Errors
         catch UITextFieldAuthenticationEmailError.empty {
            print("Please enter an email")
        } catch UITextFieldAuthenticationEmailError.invalidEmail {
            print("Please enter a valid email")
        }

        // Password Errors
         catch UITextFieldAuthenticationPasswordError.empty {
           print("Please enter a password")
        } catch UITextFieldAuthenticationPasswordError.passwordContainsNoNumbers {
            print("At least 1 number is required in the password")
        } catch UITextFieldAuthenticationPasswordError.passwordContainsNoLetters {
            print("At Least 1 letter is required in the password")
        } catch UITextFieldAuthenticationPasswordError.passwordContainsMoreCharacterLimit {
            print("The password cannot exceed \(checker.passwordMinimumLength + 1) characters in length")
        } catch UITextFieldAuthenticationPasswordError.passwordTooShort {
            print("The password must include \(checker.passwordMinimumLength) characters")
        } catch {
            print("Error uncaught = \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

