//
//  ObjectDescription.swift
//  SwiftlySalesforce
//
//  For license & details see: https://www.github.com/mike4aday/SwiftlySalesforce
//  Copyright (c) 2019. All rights reserved.

/// Salesforce object metadata.
/// See [SObject Describe](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_sobject_describe.htm).
public struct ObjectDescription: Decodable {
    
    public let fields: [FieldDescription]?
    public let isCreateable: Bool
    public let isCustom: Bool
    public let isCustomSetting: Bool
    public let isDeletable: Bool
    public let isFeedEnabled: Bool
    public let isLayoutable: Bool
    public let isQueryable: Bool
    public let isReplicateable: Bool
    public let isRetrieveable: Bool
    public let isSearchable: Bool
    public let isSearchLayoutable: Bool?
    public let isTriggerable: Bool
    public let isUndeletable: Bool
    public let isUpdateable: Bool
    public let keyPrefix: String?
    public let label: String
    public let labelPlural: String
    public let name: String
    public let supportedScopes: [SupportedScope]?
    public let recordTypeInfos: [RecordTypeInfo]?
    
    public var idPrefix: String? {
        return keyPrefix
    }
    
    public var pluralLabel: String {
        return labelPlural
    }
    
    enum CodingKeys: String, CodingKey {
        case fields
        case isCreateable = "createable"
        case isCustom = "custom"
        case isCustomSetting = "customSetting"
        case isDeletable = "deletable"
        case isFeedEnabled = "feedEnabled"
        case isLayoutable = "layoutable"
        case isQueryable = "queryable"
        case isReplicateable = "replicateable"
        case isRetrieveable = "retrieveable"
        case isSearchable = "searchable"
        case isSearchLayoutable = "searchLayoutable"
        case isTriggerable = "triggerable"
        case isUndeletable = "undeletable"
        case isUpdateable = "updateable"
        case keyPrefix
        case label
        case labelPlural
        case name
        case supportedScopes
        case recordTypeInfos
    }
}

public struct SupportedScope: Decodable {
    
    public let label: String
    public let name: String
}

public struct RecordTypeInfo: Decodable {
    
    public let isActive: Bool
    public let isAvailable: Bool
    public let defaultRecordTypeMapping: Bool
    public let developerName: String
    public let isMaster: Bool
    public let name: String
    public let recordTypeId: String
    
    enum CodingKeys: String, CodingKey {
        case isActive = "active"
        case isAvailable = "available"
        case defaultRecordTypeMapping
        case developerName
        case isMaster = "master"
        case name
        case recordTypeId
    }
}
