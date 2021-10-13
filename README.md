# Authentication Check

**This repository shows how to check username, email, and password UITextFields while creating an account for a user.**

![UITextField ErrorCheck Demo](https://user-images.githubusercontent.com/70717139/128651293-bdca203c-2817-4b20-a50b-e93718035c4c.gif)

## Table of Contents
- Features:
    - Password Constraints
    - Real World Application
    - Future Features
- Installation
- Getting Started: Evaluating Username, Email, Password and Confirm Password 
- Customization
    - Password Constraints
        - Requires at least one number
        - Requires at least one letter
        - Minimum Length
        - Maximum Length
    - Evaluation Options:
        - Evaluate with Confirm Password: Username, Email, Password and Confirm Password
        - Evaluate without Confirm Password: Username, Email and Password
    - Layouts:
        - Creating class of off the layout
        - Updating and Invalidating the layout
- Author

## Features:

- None of the fields' values can match each other's values
- The password field must be strong. More information below
- If there a problem that arises, then the appropriate UITextField would shake and become red. Furthermore, there is a message informing the user on the problem.
- If your app does not need username, AuthenticationCheck can exclude username
- Virtually everything can be customized to your liking, from password too short and long descriptions to the limit of characters and if a number is required

#### Password Constraints:
- At least 8 characters
- Must include at least 1 number and 1 letter
- Should not exceed 100 characters
- You can change these password constraints to your needs

#### This example project also shows how to:
- Exploring Swift
    - Utilize throwing Errors in a function
    - Use of completionHandlers to denote that an operation has passed
- Create an extensive and useful README.md file
- License file - MIT License
- Creating Open Source tools

#### Future Features:
- Upon entering the completionHandler, the developer can setup warnings that the evaluater has found

## Installation

Copy the AuthenticationCheck.swift file into your Authentication project

## Getting Started

### Evaluate Username, Email, Password and Confirm Password

```swift
import UIKit

class UserProfile {
    let username: String
    let email:    String
    let password: String
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email    = email
        self.password = password
    }
}

class SignUp: UIViewController {
    private let checker = AuthenticationCheck()
    
    @IBOutlet weak var usernameField:        UITextField!
    @IBOutlet weak var emailField:           UITextField!
    @IBOutlet weak var passwordField:        UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorLabel:           UILabel!
    
    @IBAction func createAnAccountAction(_ sender: Any) {
        checker.evaluateWithShake(usernameField: usernameField, emailField: emailField, passwordField: passwordField, confirmPasswordField: confirmPasswordField, currentViewController: self) {
            
            // If and when your code enters the completionHandler, that means the user satisfied the evaluater.
            print("Perfect credentials entered!")
            
            // Example code of pushing a new vc onto the current nav controller
            view.endEditing(true)
            errorLabel.isHidden = true
            errorLabel.text?.removeAll()

            let successVC = storyboard?.instantiateViewController(withIdentifier: "SuccessfullyLoggedIn") as! SuccessfullyLoggedIn
            navigationController?.pushViewController(successVC, animated: true)
            successVC.signedInUser = UserProfile(username: usernameField.text!,
                                                 email:    emailField.text!,
                                                 password: passwordField.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
```
### Customization

If you do not like the default settings, you can change virtually everything.

#### Password Requires at Least One Number

The default value is true, but you can let your users create a password without a number

```swift

// Changing the requirement to false
checker.passwordRequiresAtLeastOneNumber = false

```

#### Password Requires at Least One Letter

The default value is true, but you can change it to your needs

```swift

// Changing the requirement to false
checker.passwordRequiresAtLeastOneLetter = false

```

#### Password Minimum Length

The default value is 8, but you can change it to your needs

```swift

// Changing the password minimum length from the default(8) to 20
checker.passwordMinimumLength = 20

```

#### Password Maximum Length

The default value is 100, but you can change it to your needs

```swift

// Changing the password maximum length from the default (100) to 50
checker.passwordMaximumLength = 50

```

✏️ Make sure the minimum and maximum lengths do not conflict or else your application program will crash forcing you to fix the difference

#### Evaluation Options

If you want total or manual control of what will happen if the user fails to satisfy the evaluater, then you have 2 options:

```swift

// Use the evaluate(username:, email:, password:, confirmPassword:)
checker.evaluate(username: usernameField.text!, email: emailField.text!, password: passwordField.text!, confirmPassword: confirmPassword.text!)

// If your program does not need username:
checker.evaluate(email: emailField.text!, password: passwordField.text!, confirmPassword: confirmPassword.text!)

```

✏️ Basically, if your app uses a confirmPassword, then use the appropriate function.


Here is a very quick way to implement this:

```swift

import UIKit

class UserProfile {
    let username: String
    let email:    String
    let password: String
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email    = email
        self.password = password
    }
}

class SignUp: UIViewController {
    private let checker = AuthenticationCheck()
    
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
            successVC.signedInUser = UserProfile(username: usernameField.text!,
                                                 email:    emailField.text!,
                                                 password: passwordField.text!)
        }

        // General Errors
         catch AuthenticationCheckGeneralError.passwordContainsEmail {
             showAlert(message: "Password contains email", textFields: [usernameField, passwordField])
        } catch AuthenticationCheckGeneralError.passwordContainsUsername {
            showAlert(message: "Password contains username", textFields: [passwordField, usernameField])
        } catch AuthenticationCheckGeneralError.emailContainsPassword {
            showAlert(message: "Email contains password", textFields: [emailField, passwordField])
        } catch AuthenticationCheckGeneralError.usernameContainsEmail {
            showAlert(message: "Username contains email", textFields: [usernameField, emailField])
        } catch AuthenticationCheckGeneralError.usernameContainsPassword {
            showAlert(message: "Username contains password", textFields: [usernameField, passwordField])
        } catch AuthenticationCheckGeneralError.passwordDoesNotMatchConfirmPassword {
            showAlert(message: "Password does not match Confirm Password", textFields: [passwordField, confirmPasswordField])
        }

        // Username Error
         catch AuthenticationCheckUsernameError.empty {
            showAlert(message: "Please enter a username", textFields: [usernameField])
             usernameField.shake(baseColor: UIColor.systemPink.cgColor, numberOfShakes: 3, revert: true)
        }

        // Email Errors
         catch AuthenticationCheckEmailError.empty {
            showAlert(message: "Please enter an email", textFields: [emailField])
         } catch AuthenticationCheckEmailError.invalidEmail {
            showAlert(message: "Please enter a valid email", textFields: [emailField])
        }

        // Password Errors
         catch AuthenticationCheckPasswordError.empty {
           showAlert(message: "Please enter a password", textFields: [passwordField])
        } catch AuthenticationCheckPasswordError.passwordContainsNoNumbers {
            showAlert(message: "At least 1 number is required in the password", textFields: [passwordField])
        } catch AuthenticationCheckPasswordError.passwordContainsNoLetters {
            showAlert(message: "At Least 1 letter is required in the password", textFields: [passwordField])
        } catch AuthenticationCheckPasswordError.passwordTooLong {
            showAlert(message: "The password cannot exceed \(checker.passwordMinimumLength + 1) characters in length", textFields: [passwordField])
        } catch AuthenticationCheckPasswordError.passwordTooShort {
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
        
        for textField in textFields {
            textField.shake(baseColor: UIColor.systemPink.cgColor, numberOfShakes: 3, revert: true)
        }
    }
}

```

✏️ Even though this code looks extremely messy and horrible, you are in complete control with whatever error handling will happen

### Layouts:

If you need to manage multiple of these settings in different areas of your applications, then layouts are for you

##### Customize the layout with the **```AuthenticationCheckLayout```** protocol

```swift
import UIKit

class ViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        checker.layout = MyAuthenticationCheckLayout()
    }
}

class MyAuthenticationCheckLayout: AuthenticationCheckLayout {

    var passwordRequiresAtLeastOneNumber = false    
    var passwordRequiresAtLeastOneLetter = false
    var passwordMinimumLength = 18
    var passwordMaximumLength = 20
}
```

#### Update your panel layout

Manually set the **```AuthenticationCheck.layout```** to the new layout object directly

```swift
checker.layout = NewLayout()
checker.invalidateLayout()  // If needed
```

    
## Created and Maintained by:

[Jacob Trentini](https://github.com/Awesomeplayer165)
