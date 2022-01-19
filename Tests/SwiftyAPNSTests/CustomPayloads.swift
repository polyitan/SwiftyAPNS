//
//  CustomPayloads.swift
//  SwiftyAPNSTests
//

import Foundation
@testable import SwiftyAPNS

public struct CustomPayload1: Payloadable {
    
    public var aps: APS?
    public var acme1: String
    public var acme2: Int
    
    public init (alert: APSAlert, badge: Int?, sound: APSSound?, category: String?, acme1: String, acme2: Int) {
        self.acme1 = acme1
        self.acme2 = acme2
        self.aps = APS(alert: alert, badge: badge, sound: sound, contentAvailable: nil, mutableContent: nil, category: category)
    }
}

public struct CustomPayload2: Payloadable {
    
    public var aps: APS?
    public var acme1: [String]
    
    public init (alert: APSAlert, badge: Int?, sound: APSSound?, category: String?, acme1: [String]) {
        self.acme1 = acme1
        self.aps = APS(alert: alert, badge: badge, sound: sound, contentAvailable: nil, mutableContent: nil, category: category)
    }
}

public struct CustomPayload3: Payloadable {
    
    public var aps: APS?
    public let encrypted: String
    
    public init (alert: APSAlert, badge: Int?, sound: APSSound?, category: String?, encrypted: String) {
        var mutable = APS.mutable
        mutable.alert = alert
        mutable.badge = badge
        mutable.sound = sound
        mutable.category = category
        self.aps = mutable
        self.encrypted = encrypted
    }
}

public struct CustomPayload4: Payloadable {
    
    public var aps: APS?
    public var acme1: String
    public var acme2: Int
    
    public init (acme1: String, acme2: Int) {
        self.aps = APS.background
        self.acme1 = acme1
        self.acme2 = acme2
    }
}
