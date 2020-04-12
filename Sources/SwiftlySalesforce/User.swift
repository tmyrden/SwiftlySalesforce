//
//  User.swift
//  SwiftlySalesforce
//
//  For license & details see: https://www.github.com/mike4aday/SwiftlySalesforce
//  Copyright (c) 2019. All rights reserved.

import Foundation

public struct User: Codable {
    
    public let userID: String
    public let orgID: String
    
    public init(userID: String, orgID: String) {
        self.userID = userID
        self.orgID = orgID
    }
}
