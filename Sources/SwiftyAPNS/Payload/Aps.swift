//
//  Aps.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 21.01.2022.
//  Copyright © 2022 Sergii Tkachenko. All rights reserved.
//

/// The APS can contain one or more properties that specify the following user notification types:
/// - an alert message to display to the user
/// - a number to badge the app icon with
/// - a sound to play
public struct APS: Encodable {
    /// If this property is included, the system displays a standard alert or a banner,
    /// based on the user’s setting.
    public var alert: APSAlert?
    
    /// The number to display as the badge of the app icon.
    public var badge: Int?
    
    /// The name of a sound file or dictionary that contains sound information for critical alerts.
    public var sound: APSSound?
    
    /// Provide this key with a value of 1 to indicate that new content is available.
    public var contentAvailable: Int?
    
    /// Provide this key with a value of 1 to indicate that the content of a remote notification
    /// will be modified before it's delivered to the user.
    public var mutableContent: Int?
    
    /// Provide this key with a string value that represents the identifier property.
    public var category: String?
    
    /// Provide this key with a string value that represents the app-specific identifier for grouping notifications.
    public var threadId: String?
    
    // Provide this key with a value of the identifier of the window brought forward.
    public var targetContentId: String?
    
    /// Provide this key with a value that indicates the importance and delivery timing of notification.
    public var interruptionLevel: APSInterruptionLevel?

    /// Provide this key with a value that the system uses to sort the notifications from your app.
    /// A value between 0 and 1, the system uses to sort the notifications from your app.
    public var relevanceScore: Double?
    
    /// Keys that uses for encoding and decoding.
    private enum CodingKeys: String, CodingKey {
        case alert
        case badge
        case sound
        case contentAvailable = "content-available"
        case mutableContent = "mutable-content"
        case category
        case threadId = "thread-id"
        case targetContentId = "target-content-id"
        case interruptionLevel = "interruption-level"
        case relevanceScore = "relevance-score"
    }
}

extension APS {
    public static var background: APS {
        return APS(alert: nil, badge: nil, sound: nil, contentAvailable: 1, mutableContent: nil, category: nil, threadId: nil, targetContentId: nil, interruptionLevel: nil, relevanceScore: nil)
    }
    
    public static var mutable: APS {
        return APS(alert: nil, badge: nil, sound: nil, contentAvailable: 0, mutableContent: 1, category: nil, threadId: nil, targetContentId: nil, interruptionLevel: nil, relevanceScore: nil)
    }
}
