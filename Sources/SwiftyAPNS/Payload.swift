//
//  Payload.swift
//  Nint
//
//  Created by Tkachenko Sergey on 5/30/17.
//  Copyright © 2017 Seriy Tkachenko. All rights reserved.
//

import Foundation

/// Each remote notification includes a payload.
/// The payload contains information about how the system should alert the user as well
/// as any custom data you provide.
public struct Payload: Encodable {
    public let aps: APS
    
    public init (alert: APSAlert, badge: Int = 0, sound: String? = "default", category: String? = nil) {
        var aps = APS()
        aps.alert = alert
        aps.badge = badge
        aps.sound = sound
        aps.category = category
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
    
    /// The name of a sound file in the app bundle or in the Library/Sounds folder of
    /// the app’s data container.
    public var sound: String?
    
    /// Provide this key with a value of 1 to indicate that new content is available.
    public var contentAvailable: Int?
    
    /// Provide this key with a string value that represents the identifier property.
    public var category: String?
    
    /// Keys that uses for encoding and decoding.
    private enum CodingKeys: String, CodingKey {
        case alert
        case badge
        case sound
        case contentAvailable = "content-available"
        case category
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
        switch self {
        case .plain(let text):
            var container = encoder.singleValueContainer()
            try container.encode(text)
        case .localized(let alert):
            var container = encoder.singleValueContainer()
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
    /// A short string describing the purpose of the notification
    public var title: String?
    
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
        case body
        case titleLocKey  = "title-loc-key"
        case titleLocArgs = "title-loc-args"
        case actionLocKey = "action-loc-key"
        case locKey  = "loc-key"
        case locArgs = "loc-args"
        case launchImage = "launch-image"
    }
}
