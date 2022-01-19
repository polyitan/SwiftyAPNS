//
//  Payload.swift
//  SwiftyAPNS
//
//  Created by Tkachenko Sergii on 5/30/17.
//  Copyright © 2017 Sergii Tkachenko. All rights reserved.
//

import Foundation

public protocol Payloadable: Encodable {
    var aps: APS? { get set }
}

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

/// Can specify a string or a dictionary as the value of alert.
public enum APSAlert: Encodable {
    case plain(plain: String)
    case localized(alert: APSLocalizedAlert)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .plain(let text):
            try container.encode(text)
        case .localized(let alert):
            try container.encode(alert)
        }
    }
    
    /// Keys that uses for encoding and decoding.
    private enum CodingKeys: String, CodingKey {
        case alert
    }
}

/// Child properties of the alert property.
public struct APSLocalizedAlert: Encodable {
    /// A short string describing the purpose of the notification.
    public var title: String?
    
    /// A short string that expands on the title.
    public var subtitle: String?
    
    /// The text of the alert message.
    public var body: String?
    
    /// The key to a title string in the Localizable.strings file for the current localization.
    public var titleLocKey: String?
    
    /// Variable string values to appear in place of the format specifiers in title-loc-key.
    public var titleLocArgs: [String]?
    
    /// The key to a subtitle string in the Localizable.strings file for the current localization.
    public var subtitleLocKey: String?
    
    /// Variable string values to appear in place of the format specifiers in subtitle-loc-key.
    public var subtitleLocArgs: [String]?
    
    /// A key to an alert-message string in a Localizable.strings file for the current localization.
    public var locKey: String?
    
    /// Variable string values to appear in place of the format specifiers in loc-key.
    public var locArgs: [String]?
    
    /// If a string is specified, the system displays an alert that includes the Close and View buttons.
    public var actionLocKey: String?
    
    /// The filename of an image file in the app bundle.
    /// The image is used as the launch image when users tap the action button or move the action slider.
    public var launchImage: String?
    
    /// Keys that uses for encoding and decoding.
    private enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case body
        case titleLocKey = "title-loc-key"
        case titleLocArgs = "title-loc-args"
        case subtitleLocKey = "subtitle-loc-key"
        case subtitleLocArgs = "subtitle-loc-args"
        case locKey = "loc-key"
        case locArgs = "loc-args"
        case actionLocKey = "action-loc-key"
        case launchImage = "launch-image"
    }
}

/// Can specify a string or a dictionary as the value of alert.
public enum APSSound: Encodable {
    case regular(sound: String)
    case critical(info: APSSoundInfo)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .regular(let sound):
            try container.encode(sound)
        case .critical(let info):
            try container.encode(info)
        }
    }
    
    /// Keys that uses for encoding and decoding.
    private enum CodingKeys: String, CodingKey {
        case sound
    }
}

/// Child properties of the sound property.
public struct APSSoundInfo: Encodable {
    /// The flag that enables the critical alert.
    public var critical: Bool?
    
    /// The name of a sound file in the app bundle or in the Library/Sounds folder of
    /// the app’s data container.
    public var name: String?
    
    /// The volume for the critical alert’s sound.
    /// Set this to a value between 0 (silent) and 1 (full volume).
    public var volume: Double?
}

/// The value indicates the importance and delivery timing of notification..
public enum APSInterruptionLevel: Encodable {
    case passive
    case active
    case timeSensitive
    case critical
    
    /// Keys that uses for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case passive
        case active
        case timeSensitive = "time-sensitive"
        case critical
    }
}
