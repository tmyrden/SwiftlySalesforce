//
//  SObject.swift
//  SwiftlySalesforce
//
//  For license & details see: https://www.github.com/mike4aday/SwiftlySalesforce
//  Copyright (c) 2019. All rights reserved.

import Foundation

/// "Record" is also known as "SObject"
public typealias SObject = Record

/// Represents a record of a generic Salesforce object
public struct Record: EncodableRecord {
    
    /// Salesforce type corresponding to this record
    public var object: String
    
    /// Salesforce record ID
    public var id: String?
    
    /// Fields and their values that would be encoded for update or insert to Salesforce
    public fileprivate(set) var updatedFields = [String: Encodable?]()
    
    fileprivate var container: KeyedDecodingContainer<RecordCodingKey>?
    
    /// Subscript by field name; read only
    subscript<Value: Decodable>(field: String) -> Value? {
        return value(forField: field)
    }
    
    /// Returns the value for the given field as a String
    public func string(forField field: String) -> String? {
        return value(forField: field)
    }
    
    /// Returns the value for the given field as a Date
    public func date(forField field: String) -> Date? {
        return value(forField: field)
    }

    /// Returns the value for the given field as a URL
    public func url(forField field: String) -> URL? {
        return value(forField: field)
    }
    
    /// Returns the value for the given field as an Int
    public func int(forField field: String) -> Int? {
        return value(forField: field)
    }
    
    /// Returns the value for the given field as a Float
    public func float(forField field: String) -> Float? {
        return value(forField: field)
    }
    
    /// Returns the value for the given field as a Double
    public func double(forField field: String) -> Double? {
        return value(forField: field)
    }
    
    /// Returns the value for the given field as a Bool
    public func bool(forField field: String) -> Bool? {
        return value(forField: field)
    }
    
    public func address(forField field: String) -> Address? {
        return value(forField: field)
    }
    
    public func subqueryResult(forField field: String) -> QueryResult<Record>? {
        return value(forField: field)
    }
    
    /// Returns the value for the given field
    public func value<Value: Decodable>(forField field: String) -> Value? {
        if updatedFields.keys.contains(field) {
            return updatedFields[field] as? Value
        }
        else {
            if let c = container, let key = RecordCodingKey(stringValue: field) {
                return try? c.decode(Value.self, forKey: key)
            }
            else {
                return nil
            }
        }
    }
    
    /// Sets the value for the given field
    public mutating func setValue(_ value: Encodable?, forField field: String) {
        updatedFields.updateValue(value, forKey: field)
    }
}

extension Record: Codable {
    
    fileprivate struct RecordCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int? = nil
        init?(stringValue: String) { self.stringValue = stringValue }
        init?(intValue: Int) { return nil }
    }
    
    fileprivate struct Attributes: Decodable {
        var type: String
        var url: String?
    }
    
    fileprivate enum AttributeKeys: String, CodingKey {
        case url, type
    }
    
    public init(object: String, id: String? = nil, fields: [String: Encodable?]? = nil) {
        self.object = object
        self.id = id
        if let fields = fields {
            self.updatedFields = fields
        }
    }
    
    public init(from decoder: Decoder) throws {
        
        let topContainer = try decoder.container(keyedBy: RecordCodingKey.self)
        let attributes = try topContainer.decode(Attributes.self, forKey: RecordCodingKey(stringValue: "attributes")!)
        
        // Type of this record's Salesforce object
        self.object = attributes.type
        
        // Record ID
        if let id = try topContainer.decodeIfPresent(String.self, forKey: RecordCodingKey(stringValue: "Id")!) {
            // "Id" was one of the fields queried or retrieved
            self.id = id
        }
        else {
            if let path = attributes.url, let id = path.components(separatedBy: "/").last, id.count == 18 || id.count == 15 {
                // ID can be extracted from the record URL string
                self.id = id
            }
        }
        
        // Retain the top level container for later use
        self.container = topContainer
    }
    
    /// Encodes this record.
    /// NOTE! Only the values set by calling `setValue(_:,forField:)` are encoded; values that were decoded when the SObject was retrieved from
    /// Salesforce are not encoded here. That's by design since an `insert` or `update` operation requires only new values, and should not include fields that can't be updated, e.g. Id or CreatedDate
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RecordCodingKey.self)
        for field in updatedFields {
            let codingKey = RecordCodingKey(stringValue: field.key)!
            if let value = updatedFields[field.key], value != nil {
                if let v = value as? Bool {
                    try container.encode(v, forKey: codingKey)
                }
                else if let v = value as? Date {
                    try container.encode(v, forKey: codingKey)
                }
                else if let v = value as? Double {
                    try container.encode(v, forKey: codingKey)
                }
                else if let v = value as? Float {
                    try container.encode(v, forKey: codingKey)
                }
                else if let v = value as? Int {
                    try container.encode(v, forKey: codingKey)
                }
                else if let v = value as? String {
                    try container.encode(v, forKey: codingKey)
                }
                else if let v = value as? UInt {
                    try container.encode(v, forKey: codingKey)
                }
                else if let v = value as? URL {
                    try container.encode(v, forKey: codingKey)
                }
                else {
                    // Encode as a string if nothing else
                    try container.encode(String(describing: value), forKey: codingKey)
                }
            }
            else {
                try container.encodeNil(forKey: codingKey)
            }
        }
    }
}
