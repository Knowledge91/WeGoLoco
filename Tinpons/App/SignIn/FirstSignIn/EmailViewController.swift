//
//  EmailViewController.swift
//  Tinpons
//
//  Created by Dirk Hornung on 28/7/17.
//
//

import UIKit
import Validator
import AWSCognitoIdentityProvider
import AWSCognitoUserPoolsSignIn
import Whisper
import PromiseKit

class EmailViewController: UIViewController, LoadingAnimationProtocol{
    
    // MARK: LoadingAnimationProtocol
    var loadingAnimationIndicator: UIActivityIndicatorView!
    var loadingAnimationOverlay: UIView!
    var loadingAnimationView: UIView!
    
    var saveEmail = false
    
    var signInNavigationController: SignInNavigationController!
    
    enum ValidationErrors: String, Error {
        case minLength = "Dirección de e-mail es obligtorio"
        case emailInvalid = "Dirección de e-mail no válida."
        var message: String { return self.rawValue }
    }
    
    let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationErrors.emailInvalid)
    let minLengthRule = ValidationRuleLength(min: 1, error: ValidationErrors.minLength)
    var validationRules = ValidationRuleSet<String>()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation controller
        signInNavigationController = navigationController as! SignInNavigationController
        
        // AnimationLoaderProtocol
        loadingAnimationView = self.navigationController?.view
        
        emailTextField.becomeFirstResponder()
        emailTextField.useUnderline(UIColor.lightGray)
        
        // Validation
        validationRules.add(rule: emailRule)
        validationRules.add(rule: minLengthRule)
        
        registerButton.setTitleColor(#colorLiteral(red: 0.9646058058, green: 0.9646058058, blue: 0.9646058058, alpha: 1), for: .disabled)
        registerButton.setTitleColor(#colorLiteral(red: 0, green: 0.8166723847, blue: 0.9823040366, alpha: 1), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailTextFieldEditingChanged(_ sender: UITextField) {
        let validationResult = emailTextField.validate(rules: validationRules)
        
        switch validationResult {
        case .valid:
            emailTextField.useUnderline(#colorLiteral(red: 0.9646058058, green: 0.9646058058, blue: 0.9646058058, alpha: 1))
            guardEmail()
            registerButton.isEnabled = true
        case .invalid( _ ):
            emailTextField.useUnderline(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1))
            registerButton.isEnabled = false

        }
        
        if emailTextField.text == "" {
            emailTextField.useUnderline(#colorLiteral(red: 0.9646058058, green: 0.9646058058, blue: 0.9646058058, alpha: 1))
        }
    }
    
    @IBAction func emailTextFieldPrimaryActionTriggered(_ sender: UITextField) {
        let validationResult = emailTextField.validate(rules: validationRules)
        
        switch validationResult {
        case .valid:
            checkIfEmailExist()
        case .invalid( _ ):
            ()
        }
    }
   
    @IBAction func continueButtonTouch(_ sender: UIButton) {
       checkIfEmailExist()
    }
    
    func checkIfEmailExist() {
        startLoadingAnimation()
        firstly {
            UserAPI.isEmailAvailable(signInNavigationController.user.email!)
        }.then { isEmailAvailable -> Void in
            print("email is available : \(isEmailAvailable)")
            if isEmailAvailable {
                DispatchQueue.main.async {
                    self.stopLoadingAnimation()
                    self.onValidEmailEntered()
                }
            } else {
                DispatchQueue.main.async {
                    self.stopLoadingAnimation()
                    let message = Message(title: "Email existe ya.", backgroundColor: .red)
                    self.emailTextField.useUnderline(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1))
                    self.registerButton.isEnabled = false
                    Whisper.show(whisper: message, to: self.navigationController!, action: .show)
                }
            }
        }
    }
    
    func onValidEmailEntered() {
        startLoadingAnimation()
        firstly {
            UserAPI.update(self.signInNavigationController.user)
        }.then { Void -> Void in
            DispatchQueue.main.async {
                self.stopLoadingAnimation()
                self.signInNavigationController.pushNextViewController()
            }
        }.catch { error in
            // if we pushed register button and came from userPool just go to password
        }
    }

    func guardEmail() {
        signInNavigationController.user.email = emailTextField.text!
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guardEmail()
    }

}
