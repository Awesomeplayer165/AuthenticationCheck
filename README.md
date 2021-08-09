# UITextField-Error-Checking

**This repository shows how to check username, email, and password UITextFields while creating an account for a user.**

![UITextField ErrorCheck Demo](https://user-images.githubusercontent.com/70717139/128651293-bdca203c-2817-4b20-a50b-e93718035c4c.gif)


## Features:

#### Highlights:
- None of the fields' values can match each other's values
- The password field must be strong. More information below
- If there a problem that arises, then the appropriate UITextField would shake and become red. Furthermore, there is a message informing the user on the problem.
- If your app does not need username, ErrorChecking can exclude username

#### Password Constraints:
- At least 8 characters
- Must include at least 1 number and 1 letter
- Should not exceed 100 characters

#### This example project also shows how to:
- Utilize throwing Errors in a function.

## Installation

Copy the UITextFieldAuthenticationCheck.swift file into your Authentication project

## Getting Started

### Evaluate Username, Email, Password, and Confirm Password

```swift
import UIKit

class SignUp: UIViewController {

    // Create an instance of UITextFieldAuthenticationCheck
    private let checker = UITextFieldAuthenticationCheck()
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func createAnAccountAction(_ sender: Any) {
        do {
            // try evaluating username, email, password, and confirm password from their UITextField's respectively
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
```

### Evaluate Username, Email, Password, and Confirm Password with

```
import UIKit



```


## Created and Maintained by:

[Jacob Trentini](https://github.com/Awesomeplayer165)
