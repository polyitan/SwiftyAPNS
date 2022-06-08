//
//  APNSRequestFactory.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 08.06.2022.
//  Copyright © 2022 Sergii Tkachenko. All rights reserved.
//

import Foundation

internal final class APNSRequestFactory {
    
    private static let encoder = JSONEncoder()
    
    static func makeRequest<P: Payloadable>(_ notification: APNSNotification<P>) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = notification.options.url
        if let port = notification.options.port {
            components.port = port.rawValue
        }
        components.path = "/3/device/\(notification.token)"
        guard let url = components.url else {
            throw APNSProviderError.badUrl
        }
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        if let type = notification.options.type {
            request.setValue("\(type)", forHTTPHeaderField: "apns-push-type")
        }
        if let id = notification.options.id {
            request.setValue("\(id)", forHTTPHeaderField: "apns-id")
        }
        if let expiration = notification.options.expiration {
            request.setValue("\(expiration)", forHTTPHeaderField: "apns-expiration")
        }
        if let priority = notification.options.priority {
            request.setValue("\(priority.rawValue)", forHTTPHeaderField: "apns-priority")
        }
        if let topic = notification.options.topic {
            request.setValue("\(topic)", forHTTPHeaderField: "apns-topic")
        }
        if let collapseId = notification.options.collapseId {
            request.setValue("\(collapseId)", forHTTPHeaderField: "apns-collapse-id")
        }
        guard let payload = try? Self.encoder.encode(notification.payload) else {
            throw APNSProviderError.encodePayload
        }
        request.httpBody = payload
        return request
    }
}
