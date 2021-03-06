//
//  GenderViewController.swift
//  Tinpons
//
//  Created by Dirk Hornung on 29/7/17.
//
//

import UIKit
import PromiseKit

class GenderViewController: UIViewController, LoadingAnimationProtocol {

    // MARK: LoadingAnimationProtocol
    var loadingAnimationIndicator: UIActivityIndicatorView!
    var loadingAnimationOverlay: UIView!
    var loadingAnimationView: UIView!
    
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    var signInNavigationController: SignInNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInNavigationController = navigationController as! SignInNavigationController
        
        // LoadingAnimationProtocol
        self.loadingAnimationView = self.navigationController?.view

        // load init values + progressBar
        if let myNavigationController = self.navigationController as? SignInNavigationController {
            let gender = myNavigationController.user.gender
            if gender != "" {
                if gender == "👩‍💼" {
                    womanButton.isSelected = true
                } else if gender == "👨‍💼" {
                    manButton.isSelected = true
                }
                continueButton.isEnabled = true
            }
        }
        
        continueButton.setTitleColor(#colorLiteral(red: 0.9646058058, green: 0.9646058058, blue: 0.9646058058, alpha: 1), for: .disabled)
        continueButton.setTitleColor(#colorLiteral(red: 0, green: 0.8166723847, blue: 0.9823040366, alpha: 1), for: .normal)
        womanButton.setTitleColor(#colorLiteral(red: 0.6051923037, green: 0.383030504, blue: 0.8513439298, alpha: 1), for: .selected)
        womanButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        womanButton.adjustsImageWhenHighlighted = false
        manButton.setTitleColor(#colorLiteral(red: 0.6051923037, green: 0.383030504, blue: 0.8513439298, alpha: 1), for: .selected)
        manButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        manButton.adjustsImageWhenHighlighted = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func womanButtonTouched(_ sender: UIButton) {
      genderTouched(true)
    }

    @IBAction func manButtonTouched(_ sender: UIButton) {
        genderTouched(false)
    }
    
    @IBAction func continueButtonTouch(_ sender: UIButton) {
        startLoadingAnimation()
        firstly {
            UserAPI.update(signInNavigationController.user)
            }.then {
                DispatchQueue.main.async {
                    self.stopLoadingAnimation()
                    self.signInNavigationController?.pushNextViewController()
                }
        }
    }
    
    func genderTouched(_ isWoman: Bool) {
        if isWoman {
            womanButton.isSelected = true
            manButton.isSelected = false
        } else {
            womanButton.isSelected = false
            manButton.isSelected = true

        }
        guardGender()
        continueButton.isEnabled = true
    }
    
    func guardGender() {
        if let myNavigationController = self.navigationController as? SignInNavigationController {
            var gender = "👱"
            if womanButton.isSelected {
                gender = "👩"
            }
            myNavigationController.user.gender = gender
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guardGender()
    }

}
