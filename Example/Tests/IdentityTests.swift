//
//  IdentityTests.swift
//  SwiftlySalesforce
//
//  For license & details see: https://www.github.com/mike4aday/SwiftlySalesforce
//  Copyright (c) 2017. All rights reserved.
//

import XCTest
@testable import SwiftlySalesforce

class IdentityTests: XCTestCase {
	
	let json = """
	{
		"id" : "https://login.salesforce.com/id/00Di0000000bcK3FAI/005i00000016PdaBAE",
		"asserted_user" : true,
		"user_id" : "005i00000016PdaBAE",
		"organization_id" : "00Di0000000bcK3FAI",
		"username" : "martin@vandelayindustries.com",
		"nick_name" : "mvs",
		"display_name" : "Martin Van Nostrand",
		"email" : "martin@vandelayindustries.com",
		"email_verified" : true,
		"first_name" : "Martin",
		"last_name" : "Van Nostrand",
		"timezone" : "America/Los_Angeles",
		"photos" : {
			"picture" : "https://c.na85.content.force.com/profilephoto/005/F",
			"thumbnail" : "https://c.na85.content.force.com/profilephoto/005/T"
		},
		"addr_street" : null,
		"addr_city" : null,
		"addr_state" : null,
		"addr_country" : "US",
		"addr_zip" : "60611",
		"mobile_phone" : null,
		"mobile_phone_verified" : false,
		"is_lightning_login_user" : false,
		"status" : {
			"created_date" : null,
			"body" : null
		},
		"urls" : {
			"enterprise" : "https://na85.salesforce.com/services/Soap/c/{version}/00Di0000000bcK3",
			"metadata" : "https://na85.salesforce.com/services/Soap/m/{version}/00Di0000000bcK3",
			"partner" : "https://na85.salesforce.com/services/Soap/u/{version}/00Di0000000bcK3",
			"rest" : "https://na85.salesforce.com/services/data/v{version}/",
			"sobjects" : "https://na85.salesforce.com/services/data/v{version}/sobjects/",
			"search" : "https://na85.salesforce.com/services/data/v{version}/search/",
			"query" : "https://na85.salesforce.com/services/data/v{version}/query/",
			"recent" : "https://na85.salesforce.com/services/data/v{version}/recent/",
			"tooling_soap" : "https://na85.salesforce.com/services/Soap/T/{version}/00Di0000000bcK3",
			"tooling_rest" : "https://na85.salesforce.com/services/data/v{version}/tooling/",
			"profile" : "https://na85.salesforce.com/005i00000016PdaAAE",
			"feeds" : "https://na85.salesforce.com/services/data/v{version}/chatter/feeds",
			"groups" : "https://na85.salesforce.com/services/data/v{version}/chatter/groups",
			"users" : "https://na85.salesforce.com/services/data/v{version}/chatter/users",
			"feed_items" : "https://na85.salesforce.com/services/data/v{version}/chatter/feed-items",
			"feed_elements" : "https://na85.salesforce.com/services/data/v{version}/chatter/feed-elements"
		},
		"active" : true,
		"user_type" : "STANDARD",
		"language" : "en_US",
		"locale" : "en_US",
		"utcOffset" : -28800000,
		"last_modified_date" : "2017-03-13T16:11:13.000+0000",
		"is_app_installed" : true
	}
	"""
	
	var decoder = JSONDecoder(dateFormatter: DateFormatter.salesforceDateTimeFormatter)
	
    override func setUp() {
		super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
	
	func testThatItInits() {
		
		guard let data = json.data(using: .utf8), let identity = try? JSONDecoder(dateFormatter: .salesforceDateTimeFormatter).decode(Identity.self, from: data) else {
			XCTFail()
			return
		}
		
		XCTAssertEqual(identity.displayName, "Martin Van Nostrand")
		XCTAssertNil(identity.mobilePhone)
		XCTAssertEqual(identity.username, "martin@vandelayindustries.com")
		XCTAssertEqual(identity.userID, "005i00000016PdaBAE")
		XCTAssertEqual(identity.orgID, "00Di0000000bcK3FAI")
		XCTAssertEqual(identity.userType, "STANDARD")
		XCTAssertEqual(identity.language!, "en_US")
		XCTAssertEqual(identity.lastModifiedDate, DateFormatter.salesforceDateTimeFormatter.date(from: "2017-03-13T16:11:13.000+0000"))
		XCTAssertEqual(identity.locale!, "en_US")
		XCTAssertEqual(identity.thumbnailURL!, URL(string: "https://c.na85.content.force.com/profilephoto/005/T"))
	}
}
