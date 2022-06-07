//
//  Response.swift
//  SwiftyAPNS
//
//  Created by Tkachenko Sergii on 5/30/17.
//  Copyright © 2017 Sergii Tkachenko. All rights reserved.
//

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
