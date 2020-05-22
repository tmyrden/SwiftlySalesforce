//
//  Salesforce.swift
//  SwiftlySalesforce
//
//  For license & details see: https://www.github.com/mike4aday/SwiftlySalesforce
//  Copyright (c) 2020. All rights reserved.

import Foundation
import Combine

open class Salesforce {
    
    // MARK: - Member variables -
    
    public internal(set) var user: User?
    
    public var credential: Credential? {
        guard let u = user, let cred = credentialStore.retrieve(for: u) else {
            return nil
        }
        return cred
    }
    
    // MARK: - Constants -
    
    internal let oAuthManager: OAuthManager
    internal let credentialStore: CredentialStore
    
    // MARK: - Request configuration -
    
    public struct RequestConfig {
        
        public var version: String // Salesforce API version
        public var session: URLSession
        public var authenticateIfRequired: Bool
        public var retries: Int
        
        public static let shared = RequestConfig()
        
        public init(
            version: String = "49.0",
            session: URLSession = .shared,
            authenticateIfRequired: Bool = true,
            retries: Int = 0
        )
    }
     
    // MARK: - Initializers -
    
    public init(connectedApp: ConnectedApp, oAuthManager: OAuthManager, user: User? = nil, defaultUser: Bool = true) {
        self.oAuthManager = oAuthManager
        self.credentialStore = CredentialStore(for: connectedApp)
        self.user = user ?? (defaultUser ? self.credentialStore.lastStoredUser : nil)
    }
    
    convenience public init(connectedApp: ConnectedApp, oAuthHostname: String = "login.salesforce.com", user: User? = nil, defaultUser: Bool = true) {
        let oAuthManager = OAuthManager(connectedApp: connectedApp, hostname: oAuthHostname)
        self.init(connectedApp: connectedApp, oAuthManager: oAuthManager, user: user, defaultUser: defaultUser)
    }
    
    convenience public init(consumerKey: String, callbackURL: URL, oAuthHostname: String = "login.salesforce.com", user: User? = nil, defaultUser: Bool = true) {
        let connectedApp = ConnectedApp(consumerKey: consumerKey, callbackURL: callbackURL)
        let oAuthManager = OAuthManager(connectedApp: connectedApp, hostname: oAuthHostname)
        self.init(connectedApp: connectedApp, oAuthManager: oAuthManager, user: user, defaultUser: defaultUser)
    }
    
    // MARK: - Methods -
    
    public func identity(config: RequestConfig = .shared) -> AnyPublisher<Identity, Error> {
        let validate: (Data, URLResponse) throws -> (Data, URLResponse) = { data, response in
            if let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 403 {
                throw SalesforceError.authenticationRequired
            }
            return try Salesforce.validate(data: data, response: response)
        }
        let resource = Endpoint.identity(version: config.version)
        return makeRequest(requestConvertible: resource, validate: validate, config: config)
    }
    
    public func org(config: RequestConfig = .shared) -> AnyPublisher<Org, Error> {
        return identity(config: config)
        .flatMap { self.retrieve(object: "Organization", id: $0.orgID) }
        .eraseToAnyPublisher()
    }
    
    public func limits(config: RequestConfig = .shared) -> AnyPublisher<[String:Limit], Error> {
        let resource = Endpoint.limits(version: config.version)
        return makeRequest(requestConvertible: resource, config: config)
    }
    
    public func request<T: Decodable>(requestConvertible: URLRequestConvertible, config: RequestConfig) -> AnyPublisher<T, Error> {
        return makeRequest(requestConvertible: requestConvertible, config: config)
    }
    
    public func logOut() -> AnyPublisher<Void, Error> {
        guard let cred = self.credential else {
            return Empty().eraseToAnyPublisher()
        }
        return oAuthManager.revoke(credential: cred)
        .map { [weak self] _ in
            if let self = self {
                try? self.credentialStore.clear(credential: cred)
            }
        }.eraseToAnyPublisher()
    }
}

public enum SalesforceError: Error {
    case authenticationRequired
    case unauthorized
    case invalidRequest(message: String?)
    case invalidResponse
    case endpointFailure(statusCode: Int, errorCode: String?, message: String?, fields: [String]?)
}
