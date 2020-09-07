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
    case BadCollapseId
    case BadDeviceToken
    case BadExpirationDate
    case BadMessageId
    case BadPriority
    case BadTopic
    case DeviceTokenNotForTopic
    case DuplicateHeaders
    case IdleTimeout
    case MissingDeviceToken
    case MissingTopic
    case PayloadEmpty
    case TopicDisallowed
    ///Status code 403
    case BadCertificate
    case BadCertificateEnvironment
    case ExpiredProviderToken
    case Forbidden
    case InvalidProviderToken
    case MissingProviderToken
    ///Status code 404
    case BadPath
    ///Status code 405
    case MethodNotAllowed
    ///Status code 410
    case Unregistered
    ///Status code 413
    case PayloadTooLarge
    ///Status code 429
    case TooManyProviderTokenUpdates
    case TooManyRequests
    ///Status code 500
    case InternalServerError
    ///Status code 503
    case ServiceUnavailable
    case Shutdown
    
    public var description: String {
        switch self {
        case .BadCollapseId: return
            "The collapse identifier exceeds the maximum allowed size"
        case .BadDeviceToken: return
            """
            The specified device token was bad. Verify that the request contains a valid
            token and that the token matches the environment
            """
        case .BadExpirationDate: return
            "The apns-expiration value is bad"
        case .BadMessageId: return
            "The apns-id value is bad"
        case .BadPriority: return
            "The apns-priority value is bad"
        case .BadTopic: return
            "The apns-topic was invalid"
        case .DeviceTokenNotForTopic: return
            "The device token does not match the specified topic"
        case .DuplicateHeaders: return
            "One or more headers were repeated"
        case .IdleTimeout: return
            "Idle time out"
        case .MissingDeviceToken: return
            """
            The device token is not specified in the request :path. Verify that the :path
            header contains the device token
            """
        case .MissingTopic: return
            """
            "The apns-topic header of the request was not specified and was required. The
            apns-topic header is mandatory when the client is connected using a certificate
            that supports multiple topics
            """
        case .PayloadEmpty: return
            "The message payload was empty"
        case .TopicDisallowed: return
            "Pushing to this topic is not allowed"
        case .BadCertificate: return
            "The certificate was bad"
        case .BadCertificateEnvironment: return
            "The client certificate was for the wrong environment"
        case .ExpiredProviderToken: return
            "The provider token is stale and a new token should be generated"
        case .Forbidden: return
            "The specified action is not allowed"
        case .InvalidProviderToken: return
            "The provider token is not valid or the token signature could not be verified"
        case .MissingProviderToken: return
            """
            No provider certificate was used to connect to APNs and Authorization header
            was missing or no provider token was specified
            """
        case .BadPath: return
            "The request contained a bad :path value"
        case .MethodNotAllowed: return
            "The specified :method was not POST"
        case .Unregistered: return
            "The device token is inactive for the specified topic"
        case .PayloadTooLarge: return
            """
            The message payload was too large.
            The maximum payload size is 4096 bytes
            """
        case .TooManyProviderTokenUpdates: return
            "The provider token is being updated too often"
        case .TooManyRequests: return
            "Too many requests were made consecutively to the same device token"
        case .InternalServerError: return
            "An internal server error occurred"
        case .ServiceUnavailable: return
            "The service is unavailable"
        case .Shutdown: return
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
            self = .BadCollapseId
        case "BadDeviceToken":
            self = .BadDeviceToken
        case "BadExpirationDate":
            self = .BadExpirationDate
        case "BadMessageId":
            self = .BadMessageId
        case "BadPriority":
            self = .BadPriority
        case "BadTopic":
            self = .BadTopic
        case "DeviceTokenNotForTopic":
            self = .DeviceTokenNotForTopic
        case "DuplicateHeaders":
            self = .DuplicateHeaders
        case "IdleTimeout":
            self = .IdleTimeout
        case "MissingDeviceToken":
            self = .MissingDeviceToken
        case "MissingTopic":
            self = .MissingTopic
        case "PayloadEmpty":
            self = .PayloadEmpty
        case "TopicDisallowed":
            self = .TopicDisallowed
        case "BadCertificate":
            self = .BadCertificate
        case "BadCertificateEnvironment":
            self = .BadCertificateEnvironment
        case "ExpiredProviderToken":
            self = .ExpiredProviderToken
        case "Forbidden":
            self = .Forbidden
        case "InvalidProviderToken":
            self = .InvalidProviderToken
        case "MissingProviderToken":
            self = .MissingProviderToken
        case "BadPath":
            self = .BadPath
        case "MethodNotAllowed":
            self = .MethodNotAllowed
        case "Unregistered":
            self = .Unregistered
        case "PayloadTooLarge":
            self = .PayloadTooLarge
        case "TooManyProviderTokenUpdates":
            self = .TooManyProviderTokenUpdates
        case "TooManyRequests":
            self = .TooManyRequests
        case "InternalServerError":
            self = .InternalServerError
        case "ServiceUnavailable":
            self = .ServiceUnavailable
        case "Shutdown":
            self = .Shutdown
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
