//
//  Notification.swift
//  SwiftyAPNS
//
//  Created by Tkachenko Sergii on 5/30/17.
//  Copyright © 2017 Sergii Tkachenko. All rights reserved.
//

import Foundation

public struct APNSNotification {
    /// The Remote Notification Payload.
    public var payload: Payload
    
    /// Specify the hexadecimal string of the device token for the target device.
    public var token: String
    
    /// The optional settings for the notification
    public var options: NotificationOptions
    
    public init(payload: Payload, token: String, options: NotificationOptions = NotificationOptions.default) {
        self.payload = payload
        self.token = token
        self.options = options
    }
}
