//
//  AuthenticationCheck.swift
//  TextField ErrorChecking
//
//  Created by Jacob Trentini on 8/7/21.
//

import Foundation
import UIKit

/// Errors the user made concerning the username data
enum AuthenticationCheckUsernameError: Error {
    
    // The username field was empty
    case empty
}

/// Errors the user made concerning the email data
enum AuthenticationCheckEmailError: Error {
    
    /// The email Field was empty
    case empty
    
    /// The email entered was invalid and did not pass the REGIX evaluation
    case invalidEmail
}

/// Errors the user made concerning the password data
enum AuthenticationCheckPasswordError: Error {
    
    /// The password field was empty
    case empty
    
    /// The password contains less characters than the character requirement
    ///
    /// The default minimum length for a password is 8 characters. You change can this limit by accessing passwordMinimumLength
    case passwordTooShort
    
    /// The password contains No Numbers
    ///
    /// The password should include at least 1 number. You can change this by accessing AuthenticationCheck.passwordRequiresAtLeastOneNumber
    case passwordContainsNoNumbers
    
    /// The password contains no Letters
    ///
    /// The password should include at least 1 Letter. You can change this by accessing AuthenticationCheck.passwordRequiresAtLeastOneLetter
    case passwordContainsNoLetters
    
    /// The password contains more characters than the character limit
    ///
    ///The default maximum length for a password is 100 characters. You can change this limit by accessing the AuthenticationCheck.passwordMaximumLength
    case passwordTooLong
}

/// Errors the user made concerning the confirmPassword data
enum AuthenticationCheckConfirmPasswordError: Error {
    case empty
}

/// Errors the user made that are too general to classified
///
/// These usually contain the user entering field information that already exists in another field.
/// Even though some of these fields overlap, all of the errors are covered
enum AuthenticationCheckGeneralError: Error {
    
    /// The username contains the email
    case usernameContainsEmail
    
    /// The username contains the password
    case usernameContainsPassword
    
    /// The email contains the password
    case emailContainsPassword
    
    /// The password contains the username
    case passwordContainsUsername
    
    /// The password contains the email
    case passwordContainsEmail
    
    /// The password does not match the confirm password
    case passwordDoesNotMatchConfirmPassword
}

/// The main class that includes functions to check an application's needs for authentication
class AuthenticationCheck {
    private let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    public typealias completionHandler = () -> Void
    
    /// The password entered should have a minimum requirement of at least 1 number
    ///
    /// The default value is true
    public var passwordRequiresAtLeastOneNumber = true
    
    /// The password entered should have a minimum requirement of at least 1 letter
    ///
    /// The default value is true
    public var passwordRequiresAtLeastOneLetter = true
    
    /// The password entered should have a minimum length requirement of 8 characters. A password length of 7 will produce an Error, but a length of 8 would not
    ///
    /// The default value is 8
    public var passwordMinimumLength = 8
    
    ///The password entered should have a maximum length requirement of 100 characters. A password length of 101 will produce an Error, but a length of 100 would not
    ///
    ///The default value is 100
    public var passwordMaximumLength = 100
    
    
    /// The layout for custom settings
    ///
    /// You can have multiple different layouts for different occasions throughout your application, if needed
    public var layout:AuthenticationCheckLayout? {
        get {
            return self.layout
        }
        set {
            if let layout = newValue {
                passwordMaximumLength = layout.passwordMaximumLength
                passwordMinimumLength = layout.passwordMinimumLength
                passwordRequiresAtLeastOneNumber = layout.passwordRequiresAtLeastOneNumber
                passwordRequiresAtLeastOneLetter = layout.passwordRequiresAtLeastOneLetter
            } else {
                passwordRequiresAtLeastOneNumber = true
                passwordRequiresAtLeastOneLetter = true
                passwordMinimumLength = 8
                passwordMaximumLength = 100
            }
        }
    }
    
    
    /// Invalidating the layout resets it to the standard layout values.
    public func invalidateLayout() {
        layout = nil
    }
    
    
    /// Responsible for evaluating a username entered
    private func evaluateUsername(_ username: String) throws {
        
        /// Empty Username entered
        guard !username.isEmpty else {
            throw AuthenticationCheckUsernameError.empty
        }
    }
    
    /// Responsible for evaluating an email entered
    private func evaluateEmail(_ email: String) throws {
        
        // Empty Email entered
        guard !email.isEmpty else {
            throw AuthenticationCheckEmailError.empty
        }
        
        // Performing RegEx on Email
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailPred.evaluate(with: email) == false {
            throw AuthenticationCheckEmailError.invalidEmail
        }
    }
    
    /// Responsible for evaluating a password entered
    private func evaluatePassword(_ password: String) throws {
        
        // Empty Password entered
        guard !password.isEmpty else {
            throw AuthenticationCheckPasswordError.empty
        }
        
        // Contains more than 8 charaters
        guard password.count >= passwordMinimumLength else {
            throw AuthenticationCheckPasswordError.passwordTooShort
        }

        // Contains At Least 1 Number
        if passwordRequiresAtLeastOneNumber {
            guard password.containsAtLeastOneNumber() && passwordRequiresAtLeastOneNumber else {
                throw AuthenticationCheckPasswordError.passwordContainsNoNumbers
            }
        }
        
        // Contains At Least 1 Letter
        if passwordRequiresAtLeastOneLetter {
            guard password.containsAtLeastOneLetter() && passwordRequiresAtLeastOneLetter else {
                throw AuthenticationCheckPasswordError.passwordContainsNoLetters
            }
        }
        
        // Contains more than characterLimit characters
        guard password.count <= passwordMaximumLength else {
            throw AuthenticationCheckPasswordError.passwordTooLong
        }
    }
    
    /// Responsible for evaluating a confirm password entered
    private func evaluateConfirmPassword(_ confirmPassword: String) throws {
        
        /// Empty Confirm Password entered
        guard !confirmPassword.isEmpty else {
            throw AuthenticationCheckConfirmPasswordError.empty
        }
    }
    
    private func checkPasswordRequirements() {
        guard passwordMinimumLength > 0 else {
            fatalError("Password minimum requirement invalid. Make sure this value is not negative")
        }
        
        guard passwordMaximumLength > 0 else {
            fatalError("Password maximum requirement invalid. Make sure this value is not negative")
        }
        
        guard passwordMinimumLength < passwordMaximumLength else {
            fatalError("Conflicting Password minimum and maximum requirements. Make sure they do not conflict. Refer to the documentation for more information")
        }
    }
    
    /// This evaluates Username, Email, Password, and Confirm Password Fields.
    ///
    /// For applications that do not use usernames, use the evaluate(email:, password:, confirmPassword:) function
    /// - Parameters:
    ///   - username: The Username String the user entered
    ///   - email: The Email String the user entered
    ///   - password: The Password String the user entered
    ///   - confirmPassword: Confirm Password String
    public func evaluate(username: String, email: String, password: String, confirmPassword: String) throws {
        
        checkPasswordRequirements()
        
        guard !username.contains(email) else {
            throw AuthenticationCheckGeneralError.usernameContainsEmail
        }
        
        guard !username.contains(password) else {
            throw AuthenticationCheckGeneralError.usernameContainsPassword
        }
        
        guard !email.contains(password) else {
            throw AuthenticationCheckGeneralError.emailContainsPassword
        }
        
        guard !password.contains(username) else {
            throw AuthenticationCheckGeneralError.passwordContainsUsername
        }
        
        guard !password.contains(email) else {
            throw AuthenticationCheckGeneralError.passwordContainsEmail
        }
        
        guard password == confirmPassword else {
            throw AuthenticationCheckGeneralError.passwordDoesNotMatchConfirmPassword
        }
        
        try evaluateUsername(username)
        try evaluateEmail(email)
        try evaluatePassword(password)
    }
    
    /// This evaluates Email, Password, and Confirm Password Fields.
    ///
    /// For applications that require usernames, use the evaluate(username:, email:, password:, confirmPassword:) function
    /// - Parameters:
    ///   - email: The Email String the user entered
    ///   - password: The Password String the user entered
    ///   - confirmPassword: The Confirm Password String the user entered
    public func evaluate(email: String, password: String, confirmPassword: String) throws {
        
        checkPasswordRequirements()
        
        guard !email.contains(password) else {
            throw AuthenticationCheckGeneralError.emailContainsPassword
        }
        
        guard !password.contains(email) else {
            throw AuthenticationCheckGeneralError.passwordContainsEmail
        }
        
        guard password == confirmPassword else {
            throw AuthenticationCheckGeneralError.passwordDoesNotMatchConfirmPassword
        }
        
        try evaluateEmail(email)
        try evaluatePassword(password)
    }
    
    public func evaluateWithShake(emailField: UITextField, passwordField: UITextField, confirmPasswordField: UITextField, numberOfShakes: Float, currentViewController: UIViewController) {
        
        checkPasswordRequirements()
        
        let email = emailField.text!
        let password = passwordField.text!
        let confirmPassword = confirmPasswordField.text!
        
        guard !email.contains(password) else {
            showAlertAndShake(message: "Email Contains Password", textFields: [emailField, passwordField], currentViewController: currentViewController)
            return
        }
        
        guard !password.contains(email) else {
            showAlertAndShake(message: "Password contains Email", textFields: [emailField, passwordField], currentViewController: currentViewController)
            return
        }
        
        guard password == confirmPassword else {
            showAlertAndShake(message: "Password does not match Confirm Password field", textFields: [passwordField, confirmPasswordField], currentViewController: currentViewController)
            return
        }
        
        
        do {
            try evaluateEmail(email)
            try evaluatePassword(password)
        }

        // Email Errors
         catch AuthenticationCheckEmailError.empty {
            showAlertAndShake(message: "Please enter an email", textFields: [emailField], currentViewController: currentViewController)
         } catch AuthenticationCheckEmailError.invalidEmail {
            showAlertAndShake(message: "Please enter a valid email", textFields: [emailField], currentViewController: currentViewController)
        }

        // Password Errors
         catch AuthenticationCheckPasswordError.empty {
           showAlertAndShake(message: "Please enter a password", textFields: [passwordField], currentViewController: currentViewController)
        } catch AuthenticationCheckPasswordError.passwordContainsNoNumbers {
            showAlertAndShake(message: "At least 1 number is required in the password", textFields: [passwordField], currentViewController: currentViewController)
        } catch AuthenticationCheckPasswordError.passwordContainsNoLetters {
            showAlertAndShake(message: "At Least 1 letter is required in the password", textFields: [passwordField], currentViewController: currentViewController)
        } catch AuthenticationCheckPasswordError.passwordTooLong {
            showAlertAndShake(message: "The password cannot exceed \(passwordMinimumLength + 1) characters in length", textFields: [passwordField], currentViewController: currentViewController)
        } catch AuthenticationCheckPasswordError.passwordTooShort {
            showAlertAndShake(message: "The password must include \(passwordMinimumLength) characters", textFields: [passwordField], currentViewController: currentViewController)
        } catch {
            fatalError("Error uncaught = \(error.localizedDescription)")
        }
        
    }
    
    public func evaluateWithShake(usernameField: UITextField, emailField: UITextField, passwordField: UITextField, confirmPasswordField: UITextField, currentViewController: UIViewController, completionHandler: completionHandler) {
        
        checkPasswordRequirements()
        
        let username = usernameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        let confirmPassword = confirmPasswordField.text!
        
        guard !username.contains(email) else {
            showAlertAndShake(message: "Username contains Email", textFields: [usernameField, emailField], currentViewController: currentViewController)
            return
        }
        
        guard !username.contains(password) else {
            showAlertAndShake(message: "Username contains Password", textFields: [usernameField, emailField], currentViewController: currentViewController)
            return
        }
        
        guard !email.contains(password) else {
            showAlertAndShake(message: "Email Contains Password", textFields: [emailField, passwordField], currentViewController: currentViewController)
            return
        }
        
        guard !password.contains(email) else {
            showAlertAndShake(message: "Password contains Email", textFields: [emailField, passwordField], currentViewController: currentViewController)
            return
        }
        
        guard !password.contains(username) else {
            showAlertAndShake(message: "Password contains Username", textFields: [emailField, usernameField], currentViewController: currentViewController)
            return
        }
        
        guard password == confirmPassword else {
            showAlertAndShake(message: "Password does not match Confirm Password field", textFields: [passwordField, confirmPasswordField], currentViewController: currentViewController)
            return
        }
        
        
        do {
            try evaluateUsername(username)
            try evaluateEmail(email)
            try evaluatePassword(password)
            
            completionHandler()
        }
        
        // Username Error
         catch AuthenticationCheckUsernameError.empty {
            showAlertAndShake(message: "Please enter a username", textFields: [usernameField], currentViewController: currentViewController)
        }

        // Email Errors
         catch AuthenticationCheckEmailError.empty {
            showAlertAndShake(message: "Please enter an email", textFields: [emailField], currentViewController: currentViewController)
         } catch AuthenticationCheckEmailError.invalidEmail {
            showAlertAndShake(message: "Please enter a valid email", textFields: [emailField], currentViewController: currentViewController)
        }

        // Password Errors
         catch AuthenticationCheckPasswordError.empty {
           showAlertAndShake(message: "Please enter a password", textFields: [passwordField], currentViewController: currentViewController)
        } catch AuthenticationCheckPasswordError.passwordContainsNoNumbers {
            showAlertAndShake(message: "At least 1 number is required in the password", textFields: [passwordField], currentViewController: currentViewController)
        } catch AuthenticationCheckPasswordError.passwordContainsNoLetters {
            showAlertAndShake(message: "At Least 1 letter is required in the password", textFields: [passwordField], currentViewController: currentViewController)
        } catch AuthenticationCheckPasswordError.passwordTooLong {
            showAlertAndShake(message: "The password cannot exceed \(passwordMinimumLength + 1) characters in length", textFields: [passwordField], currentViewController: currentViewController)
        } catch AuthenticationCheckPasswordError.passwordTooShort {
            showAlertAndShake(message: "The password must include \(passwordMinimumLength) characters", textFields: [passwordField], currentViewController: currentViewController)
        } catch {
            fatalError("Error uncaught = \(error.localizedDescription)")
        }
        
    }
    
    public func evaluateWithShakeAndErrorLabel(emailField: UITextField, passwordField: UITextField, confirmPasswordField: UITextField, numberOfShakes: Float, currentViewController: UIViewController, errorLabel: UILabel, completionHandler: completionHandler) {
        
        checkPasswordRequirements()
        
        let email = emailField.text!
        let password = passwordField.text!
        let confirmPassword = confirmPasswordField.text!
        
        guard !email.contains(password) else {
            showAlertAndShakeWithErrorLabel(message: "Email Contains Password", textFields: [emailField, passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
            return
        }
        
        guard !password.contains(email) else {
            showAlertAndShakeWithErrorLabel(message: "Password contains Email", textFields: [emailField, passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
            return
        }
        
        guard password == confirmPassword else {
            showAlertAndShakeWithErrorLabel(message: "Password does not match Confirm Password field", textFields: [passwordField, confirmPasswordField], currentViewController: currentViewController, errorLabel: errorLabel)
            return
        }
        
        
        do {
            try evaluateEmail(email)
            try evaluatePassword(password)
        }

        // Email Errors
         catch AuthenticationCheckEmailError.empty {
             showAlertAndShakeWithErrorLabel(message: "Please enter an email", textFields: [emailField], currentViewController: currentViewController, errorLabel: errorLabel)
         } catch AuthenticationCheckEmailError.invalidEmail {
             showAlertAndShakeWithErrorLabel(message: "Please enter a valid email", textFields: [emailField], currentViewController: currentViewController, errorLabel: errorLabel)
        }

        // Password Errors
         catch AuthenticationCheckPasswordError.empty {
             showAlertAndShakeWithErrorLabel(message: "Please enter a password", textFields: [passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
        } catch AuthenticationCheckPasswordError.passwordContainsNoNumbers {
            showAlertAndShakeWithErrorLabel(message: "At least 1 number is required in the password", textFields: [passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
        } catch AuthenticationCheckPasswordError.passwordContainsNoLetters {
            showAlertAndShakeWithErrorLabel(message: "At Least 1 letter is required in the password", textFields: [passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
        } catch AuthenticationCheckPasswordError.passwordTooLong {
            showAlertAndShakeWithErrorLabel(message: "The password cannot exceed \(passwordMinimumLength + 1) characters in length", textFields: [passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
        } catch AuthenticationCheckPasswordError.passwordTooShort {
            showAlertAndShakeWithErrorLabel(message: "The password must include \(passwordMinimumLength) characters", textFields: [passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
        } catch {
            fatalError("Error uncaught = \(error.localizedDescription)")
        }
        
    }
    
    public func evaluateWithShakeAndErrorLabel(usernameField: UITextField, emailField: UITextField, passwordField: UITextField, confirmPasswordField: UITextField, currentViewController: UIViewController, errorLabel: UILabel, completionHandler: completionHandler) {
        
        checkPasswordRequirements()
        
        let username = usernameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        let confirmPassword = confirmPasswordField.text!
        
        guard !username.contains(email) else {
            showAlertAndShakeWithErrorLabel(message: "Username contains Email", textFields: [usernameField, emailField], currentViewController: currentViewController, errorLabel: errorLabel)
            return
        }
        
        guard !username.contains(password) else {
            showAlertAndShakeWithErrorLabel(message: "Username contains Password", textFields: [usernameField, emailField], currentViewController: currentViewController, errorLabel: errorLabel)
            return
        }
        
        guard !email.contains(password) else {
            showAlertAndShakeWithErrorLabel(message: "Email Contains Password", textFields: [emailField, passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
            return
        }
        
        guard !password.contains(email) else {
            showAlertAndShakeWithErrorLabel(message: "Password contains Email", textFields: [emailField, passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
            return
        }
        
        guard !password.contains(username) else {
            showAlertAndShakeWithErrorLabel(message: "Password contains Username", textFields: [emailField, usernameField], currentViewController: currentViewController, errorLabel: errorLabel)
            return
        }
        
        guard password == confirmPassword else {
            showAlertAndShakeWithErrorLabel(message: "Password does not match Confirm Password field", textFields: [passwordField, confirmPasswordField], currentViewController: currentViewController, errorLabel: errorLabel)
            return
        }
        
        
        do {
            try evaluateUsername(username)
            try evaluateEmail(email)
            try evaluatePassword(password)
        }
        
        // Username Error
         catch AuthenticationCheckUsernameError.empty {
             showAlertAndShakeWithErrorLabel(message: "Please enter a username", textFields: [usernameField], currentViewController: currentViewController, errorLabel: errorLabel)
        }

        // Email Errors
         catch AuthenticationCheckEmailError.empty {
             showAlertAndShakeWithErrorLabel(message: "Please enter an email", textFields: [emailField], currentViewController: currentViewController, errorLabel: errorLabel)
         } catch AuthenticationCheckEmailError.invalidEmail {
             showAlertAndShakeWithErrorLabel(message: "Please enter a valid email", textFields: [emailField], currentViewController: currentViewController, errorLabel: errorLabel)
        }

        // Password Errors
         catch AuthenticationCheckPasswordError.empty {
             showAlertAndShakeWithErrorLabel(message: "Please enter a password", textFields: [passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
        } catch AuthenticationCheckPasswordError.passwordContainsNoNumbers {
            showAlertAndShakeWithErrorLabel(message: "At least 1 number is required in the password", textFields: [passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
        } catch AuthenticationCheckPasswordError.passwordContainsNoLetters {
            showAlertAndShakeWithErrorLabel(message: "At Least 1 letter is required in the password", textFields: [passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
        } catch AuthenticationCheckPasswordError.passwordTooLong {
            showAlertAndShakeWithErrorLabel(message: "The password cannot exceed \(passwordMinimumLength + 1) characters in length", textFields: [passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
        } catch AuthenticationCheckPasswordError.passwordTooShort {
            showAlertAndShakeWithErrorLabel(message: "The password must include \(passwordMinimumLength) characters", textFields: [passwordField], currentViewController: currentViewController, errorLabel: errorLabel)
        } catch {
            fatalError("Error uncaught = \(error.localizedDescription)")
        }
        
    }
    
    private func showAlertAndShake(message:String, textFields: [UITextField], currentViewController: UIViewController) {
        let alert = UIAlertController(title: message, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        currentViewController.present(alert, animated: true, completion: nil)
        
        for textField in textFields {
            textField.shake(baseColor: UIColor.systemPink.cgColor, numberOfShakes: 3, revert: true)
        }
    }
    
    private func showAlertAndShakeWithErrorLabel(message:String, textFields: [UITextField], currentViewController: UIViewController, errorLabel: UILabel) {
        let alert = UIAlertController(title: message, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        currentViewController.present(alert, animated: true, completion: nil)
        
        errorLabel.isHidden = false
        errorLabel.text = message
        
        for textField in textFields {
            textField.shake(baseColor: UIColor.systemPink.cgColor, numberOfShakes: 3, revert: true)
        }
    }
}

/// The layout protocol itself.
protocol AuthenticationCheckLayout {
    var passwordRequiresAtLeastOneNumber:Bool { get }
    var passwordRequiresAtLeastOneLetter:Bool { get }
    var passwordMinimumLength:Int { get }
    var passwordMaximumLength:Int { get }
}

extension String {
    func containsAtLeastOneNumber() -> Bool {
        var contains = false
        
        for char in self {
            let numbersRange = String(char).rangeOfCharacter(from: .decimalDigits)
            if numbersRange != nil {
                contains = true
                continue
            }
        }
        
        return contains
    }

    func containsAtLeastOneLetter() -> Bool {
        var contains = false
        
        for char in self {
            let numbersRange = String(char).rangeOfCharacter(from: .letters)
            if numbersRange != nil {
                contains = true
                continue
            }
        }
        
        return contains
    }
}

extension UITextField {
    func shake(baseColor: CGColor, numberOfShakes shakes: Float, revert: Bool) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
        animation.fromValue = baseColor
        animation.toValue = UIColor.red.cgColor
        animation.duration = 0.4
        animation.autoreverses = revert
        self.layer.add(animation, forKey: "")

        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        shake.autoreverses = revert
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
    }
}
