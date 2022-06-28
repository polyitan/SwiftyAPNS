//
//  Provider.swift
//  SwiftyAPNS
//
//  Created by Tkachenko Sergii on 5/30/17.
//  Copyright © 2017 Sergii Tkachenko. All rights reserved.
//

import Foundation

public struct APNSProvider {
    private let provider: APNSSendMessageProtocol
    
    public func push<P: Payloadable>(_ notification: APNSNotification<P>) async throws -> APNSResponse {
        try await self.provider.push(notification)
    }
}

extension APNSProvider {
    public init(identity: SecIdentity, sandbox: Bool = true,
                configuration: URLSessionConfiguration = URLSessionConfiguration.default)
    {
        self.provider = APNSCertificateProvider(identity: identity, sandbox: sandbox, configuration: configuration)
    }
    
    public init(p8: P8, keyId: String, teamId: String, sandbox: Bool = true,
                configuration: URLSessionConfiguration = URLSessionConfiguration.default)
    {
        self.provider = APNSKeyProvider(p8: p8, keyId: keyId, teamId: teamId, sandbox: sandbox, configuration: configuration)
    }
}
