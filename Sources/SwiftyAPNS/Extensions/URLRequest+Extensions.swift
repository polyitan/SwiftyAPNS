//
//  URLRequest+Extensions.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 18.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Foundation

internal extension URLRequest {
    mutating func applyOptions(_ options: APNSNotificationOptions) {
        if let type = options.type {
            self.setValue("\(type)", forHTTPHeaderField: "apns-push-type")
        }
        
        if let id = options.id {
            self.setValue("\(id)", forHTTPHeaderField: "apns-id")
        }
        
        if let expiration = options.expiration {
            self.setValue("\(expiration)", forHTTPHeaderField: "apns-expiration")
        }
        
        if let priority = options.priority {
            self.setValue("\(priority.rawValue)", forHTTPHeaderField: "apns-priority")
        }
        
        if let topic = options.topic {
            self.setValue("\(topic)", forHTTPHeaderField: "apns-topic")
        }
        
        if let collapseId = options.collapseId {
            self.setValue("\(collapseId)", forHTTPHeaderField: "apns-collapse-id")
        }
    }
}
