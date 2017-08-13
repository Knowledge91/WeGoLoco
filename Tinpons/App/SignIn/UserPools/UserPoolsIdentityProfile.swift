//
//  AWSUserPoolsIdentityProfile.swift
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
//

import AWSMobileHubHelper
import AWSCognitoIdentityProvider
import AWSCognitoUserPoolsSignIn

class UserPoolsIdentityProfile : AWSIdentityProfile {
    
    /**
     The URL for profile image of a user.
     */
    open var imageURL: URL?
    /**
     The User Name of a user.
     */
    open var userName: String?
    
    fileprivate var userPoolProfileAttributes : [String : Any]
    
    init() {
        userPoolProfileAttributes = [String: Any]()
    }
    
    static let _sharedInstance = UserPoolsIdentityProfile()
    
    /*
     The shared instance for the profile provider.
     */
    static func sharedInstance() -> AWSIdentityProfile {
        return _sharedInstance
    }
    
    /**
     Fetches custom stored profile attribute using specified key.
     */
    func getAttributeForKey(_ key: String) -> Any? {
        return userPoolProfileAttributes[key]
    }
    
    /**
     Stores custom values using specified key.
     */
    func setProfileAttribute(_ value: Any, forKey key: String) {
        userPoolProfileAttributes[key] = value
    }
    
    /**
     Fetches the entire identity profile attributes map.
     */
    func getAttributesMap() -> [String : Any] {
        return userPoolProfileAttributes
    }
    
    /**
     Clears the current profile information.
     */
    func clear() {
        userPoolProfileAttributes = [String: Any]()
    }
    
    /**
     Loads the profile information for current signed-in user.
     */
    func load() {
        // Handle logic to load the profile of the user here
        self.userName = AWSCognitoUserPoolsSignInProvider.sharedInstance().getUserPool().currentUser()?.username
    }
    
}
