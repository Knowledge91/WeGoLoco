//
//  Tinpons.swift
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

import Foundation
import UIKit
import AWSDynamoDB

class DynamoDBTinpon: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var category: String?
    var createdAt: String?
    var imgUrl: String?
    var latitude: NSNumber?
    var longitude: NSNumber?
    var name: String?
    var price: NSNumber?
    var tinponId: String?
    var updatedAt: String?
    var userId: String?
    
    class func dynamoDBTableName() -> String {
        return "tinpons-mobilehub-1827971537-Tinpons"
    }
    
    class func hashKeyAttribute() -> String {
        return "tinponId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "category" : "category",
            "imgUrl" : "imgUrl",
            "latitude" : "latitude",
            "longitude" : "longitude",
            "name" : "name",
            "price" : "price",
            "tinponId" : "tinponId",
            "updatedAt" : "updatedAt",
            "userId" : "userId",
        ]
    }
}
