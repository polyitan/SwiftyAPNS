//
//  NotificationOptions.swift
//  SwiftyAPNS
//
//  Created by Tkachenko Sergii on 5/30/17.
//  Copyright © 2017 Sergii Tkachenko. All rights reserved.
//

/// Request headers.
public struct APNSNotificationOptions {
    /// The value of this header must accurately reflect the contents of your notifications payload.
    public var type: APNSType?
    
    /// A canonical UUID that identifies the notification.
    public var id: String?
    
    /// A UNIX epoch date expressed in seconds (UTC).
    public var expiration: Int64?
    
    /// The priority of the notification.
    public var priority: APNSPriority?
    
    /// The topic of the remote notification, which is typically the bundle ID for your app.
    public var topic: String?
    
    /// Multiple notifications with the same collapse identifier are displayed to the user as a single notification.
    public var collapseId: String?
    
    /// APNs servers
    public var environment: APNSEnvironment = .sandbox
    
    /// Port
    public var port: APNSPort?
    
    public var url: String {
        switch environment {
        case .production:
            return "api.push.apple.com"
        case .sandbox:
            return "api.development.push.apple.com"
        }
    }
}

extension APNSNotificationOptions {
    public static var `default`: APNSNotificationOptions {
        return APNSNotificationOptions()
    }
    
    public enum APNSType: String {
        case alert
        case background
        case voip
        case complication
        case fileprovider
        case mdm
    }
    
    public enum APNSPriority: Int {
        /// 10 – Send the push message immediately.
        case high = 10
        /// 5 — Send the push message at a time that takes into account power considerations for the device.
        case low = 5
    }
    
    public enum APNSEnvironment {
        case production
        case sandbox
    }

    public enum APNSPort: Int {
        case p443 = 443
        case p2197 = 2197
    }
}
