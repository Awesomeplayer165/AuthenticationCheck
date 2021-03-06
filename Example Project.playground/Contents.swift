//
//  AuthenticationCheck.swift
//  TextField ErrorChecking
//
//  Created by Jacob Trentini on 8/7/21.
//

import Foundation

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

/// The layout protocol itself.
protocol AuthenticationCheckLayout {
    var passwordRequiresAtLeastOneNumber:Bool { get }
    var passwordRequiresAtLeastOneLetter:Bool { get }
    var passwordMinimumLength:Int { get }
    var passwordMaximumLength:Int { get }
}

class MyAuthenticationLayout: AuthenticationCheckLayout {
    var passwordRequiresAtLeastOneNumber = false
    
    var passwordRequiresAtLeastOneLetter = false
    
    var passwordMinimumLength = 18
    
    var passwordMaximumLength = 20
    
}

let checker = AuthenticationCheck()
checker.layout = MyAuthenticationLayout()
checker.invalidateLayout()

do {
    try checker.evaluate(username: "bob", email: "bob@gmail.com", password: "12345678a", confirmPassword: "12345678a")
    print("Perfect Username, Email, Password, and Confirm Password!")
}

// General Errors
catch AuthenticationCheckGeneralError.passwordContainsEmail {
    print("Password contains email")
}

catch AuthenticationCheckGeneralError.passwordContainsUsername {
    print("Password contains username")
}

catch AuthenticationCheckGeneralError.emailContainsPassword {
    print("Email contains password")
}

catch AuthenticationCheckGeneralError.usernameContainsEmail {
    print("Username contains email")
}

catch AuthenticationCheckGeneralError.usernameContainsPassword {
    print("Username contains password")
}

catch AuthenticationCheckGeneralError.passwordDoesNotMatchConfirmPassword {
    print("Password does not match Confirm Password")
}

// Username Error

catch AuthenticationCheckUsernameError.empty {
    print("Please enter a username")
}

// Email Errors

catch AuthenticationCheckEmailError.empty {
    print("Please enter an email")
}

catch AuthenticationCheckEmailError.invalidEmail {
    print("Please enter a valid email")
}

// Password Errors

catch AuthenticationCheckPasswordError.empty {
   print("Please enter a password")
}

catch AuthenticationCheckPasswordError.passwordContainsNoNumbers {
    print("At least 1 number is required in the password")
}

catch AuthenticationCheckPasswordError.passwordContainsNoLetters {
    print("At Least 1 letter is required in the password")
}

catch AuthenticationCheckPasswordError.passwordTooLong {
    print("The password cannot exceed \(checker.passwordMinimumLength + 1) characters in length")
}

catch AuthenticationCheckPasswordError.passwordTooShort {
    print("The password must include \(checker.passwordMinimumLength) characters")
}

catch {
    print("Error uncaught = \(error.localizedDescription)")
}
