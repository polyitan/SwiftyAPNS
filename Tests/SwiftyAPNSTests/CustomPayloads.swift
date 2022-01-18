//
//  CustomPayloads.swift
//  SwiftyAPNSTests
//

import Foundation
@testable import SwiftyAPNS

public class CustomPayload1: APNSPayload {

    public let acme1: String
    public let acme2: Int

    public init (alert: APSAlert?, badge: Int?, sound: APSSound?, category: String?, acme1: String, acme2: Int) {
        self.acme1 = acme1
        self.acme2 = acme2
        super.init(alert: alert, badge: badge, sound: sound, contentAvailable: (alert == nil) ? 1 : nil, mutableContent: nil, category: category, threadId: nil)
    }
    
    public init (acme1: String, acme2: Int) {
        self.acme1 = acme1
        self.acme2 = acme2
        super.init(alert: nil, badge: nil, sound: nil, contentAvailable: 1, mutableContent: nil, category: nil, threadId: nil)
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(acme1, forKey: .acme1)
        try container.encode(acme2, forKey: .acme2)
    }

    private enum CodingKeys: String, CodingKey {
        case acme1
        case acme2
    }
}

public class CustomPayload2: APNSPayload {

    public let acme1: [String]

    public init (alert: APSAlert?, badge: Int?, sound: APSSound?, category: String?, acme1: [String]) {
        self.acme1 = acme1
        super.init(alert: alert, badge: badge, sound: sound, contentAvailable: (alert == nil) ? 1 : nil, mutableContent: nil, category: category, threadId: nil)
    }

    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(acme1, forKey: .acme1)
    }

    private enum CodingKeys: String, CodingKey {
        case acme1
    }
}

public class CustomPayload3: APNSPayload {

    public let encrypted: String

    public init (alert: APSAlert?, badge: Int?, sound: APSSound?, category: String?, encrypted: String) {
        self.encrypted = encrypted
        super.init(alert: alert, badge: badge, sound: sound, contentAvailable: nil, mutableContent: 1, category: category, threadId: nil)
    }

    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(encrypted, forKey: .encrypted)
    }

    private enum CodingKeys: String, CodingKey {
        case encrypted
    }
}
