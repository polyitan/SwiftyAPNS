//
//  NotificationOptions.swift
//  Nint
//
//  Created by Tkachenko Sergey on 5/30/17.
//  Copyright © 2017 Seriy Tkachenko. All rights reserved.
//

import Foundation

/// Request headers.
public struct NotificationOptions {
    /// A canonical UUID that identifies the notification.
    public var id: String?
    
    /// A UNIX epoch date expressed in seconds (UTC).
    public var expiration: Int64?
    
    /// The priority of the notification.
    public var priority: Int32?
    
    /// The topic of the remote notification, which is typically the bundle ID for your app.
    public var topic: String?
    
    /// Multiple notifications with the same collapse identifier are displayed to the user as a single notification.
    public var collapseId: String?
}

extension NotificationOptions {
    public static var `default`: NotificationOptions {
        return NotificationOptions()
    }
}
