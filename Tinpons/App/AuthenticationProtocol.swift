//
//  MainViewController.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.16
//

import UIKit
import AWSMobileHubHelper
import AWSDynamoDB
import SwiftIconFont

protocol ResetUIProtocol {
    func resetUI()
}

protocol AuthenticationProtocol: class {
    var authenticationProtocolTabBarController: UITabBarController! { get set }
    var extensionNavigationController: UINavigationController! { get set }
    func resetUI()
}

extension AuthenticationProtocol {
    func onSignIn (_ success: Bool) {
        // handle successful sign in
        if (success) {
            createUserAccountIfNotExisting()
            syncCoreDataWithDynamoDB()
            
            // reset every ViewController if User LogsIn
            authenticationProtocolTabBarController.viewControllers?.forEach{ navigationController in
                if let viewController = navigationController.childViewControllers[0] as? ResetUIProtocol {
                    viewController.resetUI()
                }
            }
        } else {
            // handle cancel operation from user
        }
    }

    func handleLogout() {
        if (AWSSignInManager.sharedInstance().isLoggedIn) {
            AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, authState: AWSIdentityManagerAuthState, error: Error?) in
                self.extensionNavigationController.popToRootViewController(animated: false)
                self.presentSignInViewController()
            })
            
            // print("Logout Successful: \(signInProvider.getDisplayName)");
        } else {
            assert(false)
        }
    }
    
    func presentSignInViewController() {
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            let loginStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
            let loginController: SignInViewController = loginStoryboard.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
            loginController.canCancel = false
            loginController.didCompleteSignIn = onSignIn
            let navController = UINavigationController(rootViewController: loginController)
            extensionNavigationController.present(navController, animated: true, completion: nil)
        }
    }
    
    func createUserAccountIfNotExisting() {
        let cognitoId = AWSMobileClient.cognitoId
        //check if User Account exists
        let dynamoDBOBjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDBOBjectMapper.load(User.self, hashKey: cognitoId, rangeKey: nil).continueWith(block: { [weak self] (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error {
                print("The request failed. Error: \(error)")
            } else if let _ = task.result as? User {
                //print("found something")
            } else if task.result == nil {
                // User does not exist => create
                let user = User()
                user?.userId = cognitoId
                user?.createdAt = Date().iso8601.dateFromISO8601?.iso8601 // "2017-03-22T13:22:13.933Z"
                user?.tinponCategories = ["👕", "👖", "👞"]
                user?.role = "User"
                dynamoDBOBjectMapper.save(user!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Void in
                    if let error = task.error {
                        print("The request failed. Error: \(error)")
                    } else {
                        print("User created")
                        // Do something with task.result or perform other operations.
                    }
                })
            }
            return nil
        })
    }
    
    func syncCoreDataWithDynamoDB() {
        SwipedTinponsCore.resetAllRecords()
        let cognitoId = AWSMobileClient.cognitoId
        SwipedTinpon().loadAllSwipedTinponsFor(userId: cognitoId, onComplete: { swipedTinpons in
            for swipedTinpon in swipedTinpons {
                SwipedTinponsCore.save(swipedTinpon: swipedTinpon)
            }
        })
        
    }
}
