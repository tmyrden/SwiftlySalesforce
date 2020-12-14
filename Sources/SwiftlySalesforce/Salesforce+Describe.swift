//
//  Salesforce+Describe.swift
//  SwiftlySalesforce
//
//  For license & details see: https://www.github.com/mike4aday/SwiftlySalesforce
//  Copyright (c) 2019. All rights reserved.

import Foundation
import Combine

extension Salesforce {
    
    /**
     Asynchronously retrieves metadata about a Salesforce object and its fields.
     See [Get Field and Other Metadata for an Object](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_sobject_describe.htm)
     - Parameter object: Name of Salesforce object
     - Parameter config: Request configuration options
     - Returns: Publisher of ObjectDescription
     */
    public func describe(object: String, config: RequestConfig = .shared) -> AnyPublisher<ObjectDescription, Error> {
        let resource = Endpoint.describe(type: object, version: config.version)
        return request(requestConvertible: resource, config: config)
    }
    
    /**
    Asynchronously retrieves metadata summaries about all Salesforce objects
    See: [Get Field and Other Metadata for an Object](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_sobject_describe.htm)
    - Parameter config: Request configuration options
    - Returns: Publisher of ObjectDescription
    */
    public func describeAllObjects(config: RequestConfig = .shared) -> AnyPublisher<[ObjectDescription], Error> {
        
        struct DescribeAllResult: Decodable {
            var sobjects: [ObjectDescription]
        }
        
        let resource = Endpoint.describeGlobal(version: config.version)
        return request(requestConvertible: resource, config: config)
        .map { (result: DescribeAllResult) -> [ObjectDescription] in
            return result.sobjects
        }
        .eraseToAnyPublisher()
    }
    
    public func describeAllLayouts(object: String, config: RequestConfig = .shared) -> AnyPublisher<[ObjectLayout], Error> {
        
        struct DescribeAllLayoutsResult: Decodable {
            var layouts: [ObjectLayout]
        }
        
        let resource = Endpoint.describeAllLayouts(type: object, version: config.version)
        return request(requestConvertible: resource, config: config)
            .map { (result: DescribeAllLayoutsResult) -> [ObjectLayout] in
                return result.layouts
            }
            .eraseToAnyPublisher()
    }
    
    public func describeLayout(object: String, id: String, config: RequestConfig = .shared) -> AnyPublisher<ObjectLayout, Error> {
        let resource = Endpoint.describeLayout(type: object, id: id, version: config.version)
        return request(requestConvertible: resource, config: config)
    }
    
    public func compactLayouts(object: String, config: RequestConfig = .shared) -> AnyPublisher<[CompactLayout], Error> {
        
        struct CompactLayoutsResult: Decodable {
            var compactLayouts: [CompactLayout]
        }
        
        let resource = Endpoint.compactLayouts(type: object, version: config.version)
        return request(requestConvertible: resource, config: config)
        .map { (result: CompactLayoutsResult) -> [CompactLayout] in
            return result.compactLayouts
        }
        .eraseToAnyPublisher()
    }
    
    public func primaryCompactLayout(object: String, config: RequestConfig = .shared) -> AnyPublisher<CompactLayout, Error> {
        let resource = Endpoint.primaryCompactLayout(type: object, version: config.version)
        return request(requestConvertible: resource, config: config)
    }
    
    public func searchLayouts(object: String, config: RequestConfig = .shared) -> AnyPublisher<[SearchLayout], Error> {
        let resource = Endpoint.searchLayouts(type: object, version: config.version)
        return request(requestConvertible: resource, config: config)
    }
}

public struct CompactLayout: Decodable {
    public let fieldItems: [LayoutField]
    public let id: String?
    public let label: String
    public let name: String
    public let objectType: String
}

public struct LayoutField: Decodable {
    public let editableForNew: Bool
    public let editableForUpdate: Bool
    public let label: String
    public let placeholder: Bool
    public let required: Bool
}

public struct SearchLayout: Decodable {
    public let label: String
    public let limitRows: Int
    public let searchColumns: [SearchColumn]
}

public struct SearchColumn: Decodable {
    public let field: String
    public let label: String
    public let name: String
}

public struct ObjectLayout: Decodable {
    public let detailLayoutSections: [LayoutSection]
    public let editLayoutSections: [LayoutSection]
    public let relatedLists: [RelatedList]
}

public struct LayoutSection: Decodable {
    public let collapsed: Bool
    public let columns: Int
    public let heading: String
    public let layoutRows: [LayoutRow]
    public let layoutSectionId: String
    public let parentLayoutId: String
    public let rows: Int
    public let tabOrder: String
    public let useCollapsibleSection: Bool
    public let useHeading: Bool
}

public struct LayoutRow: Decodable {
    public let layoutItems: [LayoutField]
    public let numItems: Int
}

public struct RelatedList: Decodable {
    public let field: String
    public let label: String
    public let limitRows: Int
    public let name: String
    public let sobject: String
    public let sort: [RelatedListSort]
}

public struct RelatedListSort: Decodable {
    public let ascending: Bool
    public let column: String
}
