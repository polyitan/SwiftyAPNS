//
//  LocalizedAlert.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 21.01.2022.
//  Copyright © 2022 Sergii Tkachenko. All rights reserved.
//

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
