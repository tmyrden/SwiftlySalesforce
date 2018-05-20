//
//  Authorization.swift
//  SwiftlySalesforce
//
//  Created by Michael Epstein on 5/14/18.
//

import Foundation

public struct Authorization {
	
	let accessToken: String
	let refreshToken: String?
	let instanceURL: URL
	let identityURL: URL
	
	init(withRedirectURL redirectURL: URL) throws {
		
		// Salesforce returns authorization result in the redirect URL's fragment
		// so let's make it a query string instead so we can parse with URLComponents
		guard
			let url = URL(string: redirectURL.absoluteString.replacingOccurrences(of: "#", with: "?")),
			let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
			let accessToken = queryItems.filter({$0.name == "access_token"}).first?.value,
			let instanceURLString = queryItems.filter({$0.name == "instance_url"}).first?.value,
			let instanceURL = URL(string: instanceURLString),
			let identityURLString = queryItems.filter({$0.name == "id"}).first?.value,
			let identityURL = URL(string: identityURLString)
		else {
			throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: [NSURLErrorFailingURLStringErrorKey: redirectURL])
		}
		self.accessToken = accessToken
		self.refreshToken = queryItems.filter({ $0.name == "refresh_token" }).first?.value
		self.instanceURL = instanceURL
		self.identityURL = identityURL
	}
}
