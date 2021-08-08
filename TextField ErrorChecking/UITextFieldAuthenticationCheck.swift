//
//  UITextFieldAuthenticationCheck.swift
//  TextField ErrorChecking
//
//  Created by Jacob Trentini on 8/7/21.
//

import Foundation

/// Errors the user made concerning the username data
enum UITextFieldAuthenticationUsernameError: Error {
    
    // The username field was empty
    case empty
}

/// Errors the user made concerning the email data
enum UITextFieldAuthenticationEmailError: Error {
    
    /// The email Field was empty
    case empty
    
    /// The email entered was invalid and did not pass the REGIX evaluation
    case invalidEmail
}

/// Errors the user made concerning the password data
enum UITextFieldAuthenticationPasswordError: Error {
    
    /// The password field was empty
    case empty
    
    /// The password was too short
    ///
    /// The minimum length for a password is 8 characters
    case passwordTooShort
    
    /// The password contains No Numbers
    ///
    /// The password should include at least 1 number. You can change this by accessing
    case passwordContainsNoNumbers
    
    /// The password contains no Letters
    ///
    /// The password should include at least 1 Letter. You can change this by accessing
    case passwordContainsNoLetters
    
    /// The password contains more characters than the character limit
    case passwordContainsMoreCharacterLimit
}

/// Errors the user made concerning the confirmPassword data
enum UITextFieldAuthenticationConfirmPasswordError: Error {
    case empty
}

/// Errors the user made that are too general to classified
///
/// These usually contain the user entering field information that already exists in another field.
/// Even though some of these fields overlap, all of the errors are covered
enum UITextFieldAuthenticationGeneralError: Error {
    
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
class UITextFieldAuthenticationCheck {
    private let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
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
    
    
    /// Responsible for evaluating a username entered
    private func evaluateUsername(_ username: String) throws {
        
        /// Empty Username entered
        guard !username.isEmpty else {
            throw UITextFieldAuthenticationUsernameError.empty
        }
    }
    
    /// Responsible for evaluating an email entered
    private func evaluateEmail(_ email: String) throws {
        
        // Empty Email entered
        guard !email.isEmpty else {
            throw UITextFieldAuthenticationEmailError.empty
        }
        
        // Performing RegEx on Email
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailPred.evaluate(with: email) == false {
            throw UITextFieldAuthenticationEmailError.invalidEmail
        }
    }
    
    /// Responsible for evaluating a password entered
    private func evaluatePassword(_ password: String) throws {
        
        // Empty Password entered
        guard !password.isEmpty else {
            throw UITextFieldAuthenticationPasswordError.empty
        }
        
        // Contains more than 8 charaters
        guard password.count >= passwordMinimumLength else {
            throw UITextFieldAuthenticationPasswordError.passwordTooShort
        }

        // Contains At Least 1 Number
        if passwordRequiresAtLeastOneNumber {
            guard password.containsAtLeastOneNumber() && passwordRequiresAtLeastOneNumber else {
                throw UITextFieldAuthenticationPasswordError.passwordContainsNoNumbers
            }
        }
        
        // Contains At Least 1 Letter
        if passwordRequiresAtLeastOneLetter {
            guard password.containsAtLeastOneLetter() && passwordRequiresAtLeastOneLetter else {
                throw UITextFieldAuthenticationPasswordError.passwordContainsNoLetters
            }
        }
        
        // Contains more than characterLimit characters
        guard password.count <= passwordMaximumLength else {
            throw UITextFieldAuthenticationPasswordError.passwordContainsMoreCharacterLimit
        }
    }
    
    /// Responsible for evaluating a confirm password entered
    private func evaluateConfirmPassword(_ confirmPassword: String) throws {
        
        /// Empty Confirm Password entered
        guard !confirmPassword.isEmpty else {
            throw UITextFieldAuthenticationConfirmPasswordError.empty
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
        guard !username.contains(email) else {
            throw UITextFieldAuthenticationGeneralError.usernameContainsEmail
        }
        
        guard !username.contains(password) else {
            throw UITextFieldAuthenticationGeneralError.usernameContainsPassword
        }
        
        guard !email.contains(password) else {
            throw UITextFieldAuthenticationGeneralError.emailContainsPassword
        }
        
        guard !password.contains(username) else {
            throw UITextFieldAuthenticationGeneralError.passwordContainsUsername
        }
        
        guard !password.contains(email) else {
            throw UITextFieldAuthenticationGeneralError.passwordContainsEmail
        }
        
        guard password == confirmPassword else {
            throw UITextFieldAuthenticationGeneralError.passwordDoesNotMatchConfirmPassword
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
        guard !email.contains(password) else {
            throw UITextFieldAuthenticationGeneralError.emailContainsPassword
        }
        
        guard !password.contains(email) else {
            throw UITextFieldAuthenticationGeneralError.passwordContainsEmail
        }
        
        guard password == confirmPassword else {
            throw UITextFieldAuthenticationGeneralError.passwordDoesNotMatchConfirmPassword
        }
        
        try evaluateEmail(email)
        try evaluatePassword(password)
    }
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
