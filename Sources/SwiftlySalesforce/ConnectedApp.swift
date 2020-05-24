//
//  ConnectedApp.swift
//  SwiftlySalesforce
//
//  For license & details see: https://www.github.com/mike4aday/SwiftlySalesforce
//  Copyright (c) 2019. All rights reserved.
//

import Foundation

/// Represents a Salesforce Connected App
/// See [Connected Apps](https://help.salesforce.com/articleView?id=connected_app_overview.htm&type=5).
public struct ConnectedApp {
    
    let consumerKey: String
    let callbackURL: URL
    
    static var `default`: ConnectedApp? {
        if let consumerKey = Bundle.main.object(forInfoDictionaryKey: "ConsumerKey") as? String,
            let callbackURLString = Bundle.main.object(forInfoDictionaryKey: "CallbackURL") as? String,
            let callbackURL = URL(string: callbackURLString) {
            return ConnectedApp(consumerKey: consumerKey, callbackURL: callbackURL)
        }
        else {
            return nil
        }
    }
    
    public init(consumerKey: String, callbackURL: URL) {
        self.consumerKey = consumerKey
        self.callbackURL = callbackURL
    }
}
