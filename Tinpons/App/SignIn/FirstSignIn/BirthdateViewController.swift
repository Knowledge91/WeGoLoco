//
//  PasswordViewController.swift
//  Tinpons
//
//  Created by Dirk Hornung on 28/7/17.
//
//

import UIKit

class BirthdateViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var birthdatePicker: UIDatePicker!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let myNavigationController = self.navigationController as? SignInNavigationController {
            myNavigationController.progressView.progress = 0.56
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBirthdate()
        
        continueButton.setTitleColor(#colorLiteral(red: 0.9646058058, green: 0.9646058058, blue: 0.9646058058, alpha: 1), for: .disabled)
        continueButton.setTitleColor(#colorLiteral(red: 0.5695158243, green: 0.7503048182, blue: 0.9790232778, alpha: 1), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadBirthdate() {
        if let myNavigationController = self.navigationController as? SignInNavigationController {
            if let birthdate = myNavigationController.user.birthdate {
                birthdatePicker.date = birthdate
            } else {
                birthdatePicker.date = Date()
            }
            continueButton.isEnabled = true
        }
    }
    
    func guardBirthdate() {
        if let myNavigationController = self.navigationController as? SignInNavigationController {
            myNavigationController.user.birthdate = birthdatePicker.date
        }
    }

    @IBAction func birthdatePickerValueChanged(_ sender: UIDatePicker) {
        guardBirthdate()
        continueButton.isEnabled = true
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guardBirthdate()
    }

}