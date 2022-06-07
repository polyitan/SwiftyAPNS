//
//  Status.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 29.04.2022.
//  Copyright © 2022 Sergii Tkachenko. All rights reserved.
//

/// The HTTP status code.
public enum APNSStatus: Int {
    case success = 200      // Success
    case badRequest = 400   // Bad request
    case forbidden = 403    // There was an error with the certificate or with the provider authentication token
    case methodNotAllowed = 405 // The request used a bad method value. Only POST requests are support
    case unregistered = 410     // The device token is no longer active for the topic
    case payloadTooLarge = 413  // The notification payload was too large
    case tooManyRequests = 429  // The server received too many requests for the same device token
    case internalServerError = 500  // Internal server error
    case serviceUnavailable = 503   // The server is shutting down and unavailable
}

extension APNSStatus {
    public init?(code: Int) {
        self.init(rawValue: code)
    }
}

extension APNSStatus: CustomStringConvertible {
    public var description: String {
        var statusDescription = "APNS Status: "
        switch self {
        case .success:
            statusDescription += "Success"
        case .badRequest:
            statusDescription += "Bad request"
        case .forbidden:
            statusDescription += "There was an error with the certificate or with the provider authentication token"
        case .methodNotAllowed:
            statusDescription += "The request used a bad method value. Only POST requests are support"
        case .unregistered:
            statusDescription += "The device token is no longer active for the topic"
        case .payloadTooLarge:
            statusDescription += "The notification payload was too large"
        case .tooManyRequests:
            statusDescription += "The server received too many requests for the same device token"
        case .internalServerError:
            statusDescription += "Internal server error"
        case .serviceUnavailable:
            statusDescription += "The server is shutting down and unavailable"
        }
        return statusDescription
    }
}
