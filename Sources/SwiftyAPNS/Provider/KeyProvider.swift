//
//  KeyProvider.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 11.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Foundation

internal final class APNSKeyProvider: APNSSendMessageProtocol {
    
    private let token: APNSBearerToken
    private let session: URLSession
    
    private static let decoder = JSONDecoder()
    
    public init(p8: P8, keyId: String, teamId: String, sandbox: Bool = true,
                configuration: URLSessionConfiguration = URLSessionConfiguration.default)
    {
        self.token = APNSBearerToken(p8: p8, keyId: keyId, teamId: teamId)
        self.session = URLSession.init(configuration: configuration)
    }
    
    public func push<P: Payloadable>(_ notification: APNSNotification<P>) async throws -> APNSResponse {
        var request = try APNSRequestFactory.makeRequest(notification)
        let dataToken = try token.generateIfExpired()
        request.setValue("application/json;", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer \(dataToken)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await session.data(for: request)
        if let responce = response as? HTTPURLResponse,
           let apnsStatus = APNSStatus(code: responce.statusCode),
           let apnsId = responce.allHeaderFields["apns-id"] as? String {
            let reason = try? Self.decoder.decode(APNSError.self, from: data)
            return APNSResponse(status: apnsStatus, apnsId: apnsId, reason: reason)
        } else {
            throw APNSProviderError.parseResponce
        }
    }
}
