//
//  PasswordViewController.swift
//  Tinpons
//
//  Created by Dirk Hornung on 3/8/17.
//
//

import UIKit
import Validator
import AWSCognitoUserPoolsSignIn
import AWSMobileHubHelper


class PasswordViewController: UIViewController, LoadingAnimationProtocol {
    
    // MARK: LoadingAnimationProtocol
    var loadingAnimationIndicator: UIActivityIndicatorView!
    var loadingAnimationOverlay: UIView!
    var loadingAnimationView: UIView!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var pool: AWSCognitoIdentityUserPool?
    var userId = UUID().uuidString
    
    enum ValidationErrors: String, Error {
        case minLength = "Contraseña es obligtorio"
        case passwordInvalid = "Contraseñna no válida."
        var message: String { return self.rawValue }
    }
    
    let minLengthRule = ValidationRuleLength(min: 8, error: ValidationErrors.minLength)
    var validationRules = ValidationRuleSet<String>()
    var signInNavigationController: SignInNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInNavigationController = navigationController as! SignInNavigationController
        
        self.pool = AWSCognitoIdentityUserPool.default()
        
        // AnimationLoaderProtocol
        loadingAnimationView = self.navigationController?.view
        
        passwordTextField.becomeFirstResponder()
        passwordTextField.useUnderline(UIColor.lightGray)
        
        // Validation
        validationRules.add(rule: minLengthRule)
        
        continueButton.setTitleColor(#colorLiteral(red: 0.9646058058, green: 0.9646058058, blue: 0.9646058058, alpha: 1), for: .disabled)
        continueButton.setTitleColor(#colorLiteral(red: 0, green: 0.8166723847, blue: 0.9823040366, alpha: 1), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueButtonTouch(_ sender: UIButton) {
        let validationResult = passwordTextField.validate(rules: validationRules)
        
        switch validationResult {
        case .valid:
            continueWithValidPassword()
        case .invalid( _ ):
            ()
        }
    }
    
    @IBAction func passwordTextFieldEditingChanged(_ sender: UITextField) {
        let validationResult = passwordTextField.validate(rules: validationRules)
        
        switch validationResult {
        case .valid:
            passwordTextField.useUnderline(#colorLiteral(red: 0.9646058058, green: 0.9646058058, blue: 0.9646058058, alpha: 1))
            continueButton.isEnabled = true
        case .invalid( _ ):
            passwordTextField.useUnderline(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1))
            continueButton.isEnabled = false
        }
        
        if passwordTextField.text == "" {
            passwordTextField.useUnderline(#colorLiteral(red: 0.9646058058, green: 0.9646058058, blue: 0.9646058058, alpha: 1))
        }
    }

    @IBAction func passwordTextFieldPrimaryActionTriggered(_ sender: UITextField) {
        let validationResult = passwordTextField.validate(rules: validationRules)
        
        switch validationResult {
        case .valid:
             continueWithValidPassword()
        case .invalid( _ ):
            ()
        }
    }
    
    func continueWithValidPassword() {}
    
    func guardUserId() {
        if let myNavigationController = self.navigationController as? SignInNavigationController {
            myNavigationController.user.id = userId
        }
    }
    
    func guardPassword() {
        signInNavigationController.user.password = passwordTextField.text
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guardUserId()
        guardPassword()
        
        if let signUpConfirmationViewController = segue.destination as? EmailConfirmationViewController {
            signUpConfirmationViewController.user = self.pool?.getUser(userId)
        }
    }


}
