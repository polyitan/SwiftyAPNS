//
//  Payload.swift
//  SwiftyAPNS
//
//  Created by Tkachenko Sergii on 5/30/17.
//  Copyright © 2017 Sergii Tkachenko. All rights reserved.
//

import Foundation

/// Each remote notification includes a payload.
/// The payload contains information about how the system should alert the user as well
/// as any custom data you provide.
public class APNSPayload: Encodable {
    public var aps: APS?
    
    public init(alert: APSAlert?, badge: Int?, sound: String?, contentAvailable: Int?, mutableContent: Int?, category: String?, threadId: String?) {
        var aps = APS()
        aps.alert = alert
        aps.badge = badge
        aps.sound = sound
        aps.contentAvailable = contentAvailable
        aps.mutableContent = mutableContent
        aps.category = category
        aps.threadId = threadId
        self.aps = aps
    }
    
    public convenience init(alert: APSAlert?, badge: Int? = 0, sound: String? = "default") {
        self.init(alert: alert, badge: badge, sound: sound, contentAvailable: nil, mutableContent: nil, category: nil, threadId: nil)
    }
    
    public convenience init(alert: APSAlert?, badge: Int? = 0, sound: String? = "default", category: String? = nil) {
        self.init(alert: alert, badge: badge, sound: sound, contentAvailable: nil, mutableContent: nil, category: category, threadId: nil)
    }
    
    public static var background: APNSPayload {
        return APNSPayload(alert: nil, badge: nil, sound: nil, contentAvailable: 1, mutableContent: nil, category: nil, threadId: nil)
    }
    
    public static var mutable: APNSPayload {
        return APNSPayload(alert: nil, badge: nil, sound: nil, contentAvailable: 0, mutableContent: 1, category: nil, threadId: nil)
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
    
    /// The name of a sound file in the app bundle or in the Library/Sounds folder of
    /// the app’s data container.
    public var sound: String?
    
    /// Provide this key with a value of 1 to indicate that new content is available.
    public var contentAvailable: Int?
    
    /// Provide this key with a value of 1 to indicate that the content of a remote notification
    /// will be modified before it's delivered to the user.
    public var mutableContent: Int?
    
    /// Provide this key with a string value that represents the identifier property.
    public var category: String?
    
    /// Provide this key with a string value that represents the app-specific identifier for grouping notifications.
    public var threadId: String?
    
    /// Keys that uses for encoding and decoding.
    private enum CodingKeys: String, CodingKey {
        case alert
        case badge
        case sound
        case contentAvailable = "content-available"
        case mutableContent = "mutable-content"
        case category
        case threadId = "thread-id"
    }
}

/// Can specify a string or a dictionary as the value of alert.
public enum APSAlert {
    case plain(
        plain: String
    )
    case localized(
        alert: APSLocalizedAlert
    )
}

extension APSAlert: Encodable {
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
    
    /// If a string is specified, the system displays an alert that includes the Close and View buttons.
    public var actionLocKey: String?
    
    /// A key to an alert-message string in a Localizable.strings file for the current localization.
    public var locKey: String?
    
    /// Variable string values to appear in place of the format specifiers in loc-key.
    public var locArgs: [String]?
    
    /// The filename of an image file in the app bundle.
    /// The image is used as the launch image when users tap the action button or move the action slider.
    public var launchImage: String?
    
    /// Keys that uses for encoding and decoding.
    private enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case body
        case titleLocKey  = "title-loc-key"
        case titleLocArgs = "title-loc-args"
        case actionLocKey = "action-loc-key"
        case locKey  = "loc-key"
        case locArgs = "loc-args"
        case launchImage = "launch-image"
    }
}
