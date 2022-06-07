//
//  Error.swift
//  SwiftyAPNS
//
//  Created by Tkachenko Sergii on 5/30/17.
//  Copyright © 2017 Sergii Tkachenko. All rights reserved.
//

import Foundation

/// The APNS reasons.
public enum APNSError: Error {
    /// Status code 400
    case badCollapseId
    case badDeviceToken
    case badExpirationDate
    case badMessageId
    case badPriority
    case badTopic
    case deviceTokenNotForTopic
    case duplicateHeaders
    case idleTimeout
    case missingDeviceToken
    case missingTopic
    case payloadEmpty
    case topicDisallowed
    /// Status code 403
    case badCertificate
    case badCertificateEnvironment
    case expiredProviderToken
    case forbidden
    case invalidProviderToken
    case missingProviderToken
    /// Status code 404
    case badPath
    /// Status code 405
    case methodNotAllowed
    /// Status code 410
    case unregistered
    /// Status code 413
    case payloadTooLarge
    /// Status code 429
    case tooManyProviderTokenUpdates
    case tooManyRequests
    /// Status code 500
    case internalServerError
    /// Status code 503
    case serviceUnavailable
    case shutdown
}

extension APNSError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badCollapseId: return
            "The collapse identifier exceeds the maximum allowed size"
        case .badDeviceToken: return
            """
            The specified device token was bad. Verify that the request contains a valid
            token and that the token matches the environment
            """
        case .badExpirationDate: return
            "The apns-expiration value is bad"
        case .badMessageId: return
            "The apns-id value is bad"
        case .badPriority: return
            "The apns-priority value is bad"
        case .badTopic: return
            "The apns-topic was invalid"
        case .deviceTokenNotForTopic: return
            "The device token does not match the specified topic"
        case .duplicateHeaders: return
            "One or more headers were repeated"
        case .idleTimeout: return
            "Idle time out"
        case .missingDeviceToken: return
            """
            The device token is not specified in the request :path. Verify that the :path
            header contains the device token
            """
        case .missingTopic: return
            """
            "The apns-topic header of the request was not specified and was required. The
            apns-topic header is mandatory when the client is connected using a certificate
            that supports multiple topics
            """
        case .payloadEmpty: return
            "The message payload was empty"
        case .topicDisallowed: return
            "Pushing to this topic is not allowed"
        case .badCertificate: return
            "The certificate was bad"
        case .badCertificateEnvironment: return
            "The client certificate was for the wrong environment"
        case .expiredProviderToken: return
            "The provider token is stale and a new token should be generated"
        case .forbidden: return
            "The specified action is not allowed"
        case .invalidProviderToken: return
            "The provider token is not valid or the token signature could not be verified"
        case .missingProviderToken: return
            """
            No provider certificate was used to connect to APNs and Authorization header
            was missing or no provider token was specified
            """
        case .badPath: return
            "The request contained a bad :path value"
        case .methodNotAllowed: return
            "The specified :method was not POST"
        case .unregistered: return
            "The device token is inactive for the specified topic"
        case .payloadTooLarge: return
            """
            The message payload was too large.
            The maximum payload size is 4096 bytes
            """
        case .tooManyProviderTokenUpdates: return
            "The provider token is being updated too often"
        case .tooManyRequests: return
            "Too many requests were made consecutively to the same device token"
        case .internalServerError: return
            "An internal server error occurred"
        case .serviceUnavailable: return
            "The service is unavailable"
        case .shutdown: return
            "The server is shutting down"
        }
    }
}

extension APNSError: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let reason = try container.decode(String.self, forKey: .reason)
        switch reason {
        case "BadCollapseId":
            self = .badCollapseId
        case "BadDeviceToken":
            self = .badDeviceToken
        case "BadExpirationDate":
            self = .badExpirationDate
        case "BadMessageId":
            self = .badMessageId
        case "BadPriority":
            self = .badPriority
        case "BadTopic":
            self = .badTopic
        case "DeviceTokenNotForTopic":
            self = .deviceTokenNotForTopic
        case "DuplicateHeaders":
            self = .duplicateHeaders
        case "IdleTimeout":
            self = .idleTimeout
        case "MissingDeviceToken":
            self = .missingDeviceToken
        case "MissingTopic":
            self = .missingTopic
        case "PayloadEmpty":
            self = .payloadEmpty
        case "TopicDisallowed":
            self = .topicDisallowed
        case "BadCertificate":
            self = .badCertificate
        case "BadCertificateEnvironment":
            self = .badCertificateEnvironment
        case "ExpiredProviderToken":
            self = .expiredProviderToken
        case "Forbidden":
            self = .forbidden
        case "InvalidProviderToken":
            self = .invalidProviderToken
        case "MissingProviderToken":
            self = .missingProviderToken
        case "BadPath":
            self = .badPath
        case "MethodNotAllowed":
            self = .methodNotAllowed
        case "Unregistered":
            self = .unregistered
        case "PayloadTooLarge":
            self = .payloadTooLarge
        case "TooManyProviderTokenUpdates":
            self = .tooManyProviderTokenUpdates
        case "TooManyRequests":
            self = .tooManyRequests
        case "InternalServerError":
            self = .internalServerError
        case "ServiceUnavailable":
            self = .serviceUnavailable
        case "Shutdown":
            self = .shutdown
        default:
            throw CodingError.unknownValue
        }
    }
    
    /// Keys that uses for throw errors
    private enum CodingError: Error {
        case unknownValue
    }
    
    /// Keys that uses for encoding and decoding.
    private enum CodingKeys: CodingKey {
        case reason
    }
}
