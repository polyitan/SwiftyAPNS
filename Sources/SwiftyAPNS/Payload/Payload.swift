//
//  Payload.swift
//  SwiftyAPNS
//
//  Created by Tkachenko Sergii on 5/30/17.
//  Copyright © 2017 Sergii Tkachenko. All rights reserved.
//

/// Each remote notification includes a payload.
/// The payload contains information about how the system should alert the user as well
/// as any custom data you provide.
public struct APNSPayload: Payloadable {
    public var aps: APS?
}

extension APNSPayload {
    public init(alert: APSAlert?) {
        var aps = APS()
        aps.alert = alert
        aps.badge = 0
        aps.sound = .regular(sound: "default")
        self.aps = aps
    }
    
    public init(alert: APSAlert?, badge: Int?, sound: APSSound? = .regular(sound: "default"), category: String? = nil) {
        var aps = APS()
        aps.alert = alert
        aps.badge = badge
        aps.sound = sound
        aps.category = category
        self.aps = aps
    }
    
    public init(alert: APSAlert?, badge: Int?, sound: APSSound?, contentAvailable: Int? = nil, mutableContent: Int? = nil, category: String? = nil, threadId: String? = nil, targetContentId: String? = nil, interruptionLevel: APSInterruptionLevel? = nil, relevanceScore: Double? = nil) {
        var aps = APS()
        aps.alert = alert
        aps.badge = badge
        aps.sound = sound
        aps.contentAvailable = contentAvailable
        aps.mutableContent = mutableContent
        aps.category = category
        aps.threadId = threadId
        aps.targetContentId = targetContentId
        aps.interruptionLevel = interruptionLevel
        aps.relevanceScore = relevanceScore
        self.aps = aps
    }
}
