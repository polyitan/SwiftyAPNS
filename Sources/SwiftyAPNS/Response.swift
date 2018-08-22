//
//  Response.swift
//  Nint
//
//  Created by Tkachenko Sergey on 5/30/17.
//  Copyright © 2017 Seriy Tkachenko. All rights reserved.
//

import Foundation

/// The HTTP status code.
public enum APNSStatus: Int {
    case success = 200      // Success
    case badRequest = 400   // Bad request
    case forbidden = 403    // There was an error with the certificate.
    case methodNotAllowed = 405 // The request used a bad method value. Only POST requests are support
    case unregistered = 410     // The device token is no longer active for the topic.
    case payloadTooLarge = 413  // The notification payload was too large.
    case tooManyRequests = 429  // The server received too many requests for the same device token.
    case internalServerError = 500  // Internal server error
    case serviceUnavailable = 503   // The server is shutting down and unavailable.
}

extension APNSStatus {
    public init?(code: Int) {
        self.init(rawValue: code)
    }
}

/// The response of request.
public struct APNSResponse {
    /// Status codes for a response
    public let status: APNSStatus
    
    /// The apns-id value from the request.
    /// If no value was included in the request,
    /// the server creates a new UUID and returns it in this header.
    public let apnsId: String
    
    /// The error indicating the reason for the failure.
    public let reason: APNSError?
    
    /// If the value in the :status header is 410, the value of this key is the last time
    /// at which APNs confirmed that the device token was no longer valid for the topic.
    /// Stop pushing notifications until the device registers a token with
    /// a later timestamp with your provider.
    //let timestamp: TimeInterval?
    
    public init(status: APNSStatus, apnsId: String, reason: APNSError?) {
        self.status = status
        self.apnsId = apnsId
        self.reason = reason
    }
}
