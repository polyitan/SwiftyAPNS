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
    
    public func push<P: Payloadable>(_ notification: APNSNotification<P>, completion: @escaping (Result<APNSResponse, Error>) -> Void) {
        self.provider.push(notification, completion: completion)
    }
}

extension APNSProvider {
    public init(identity: SecIdentity, sandbox: Bool = true,
                configuration: URLSessionConfiguration = URLSessionConfiguration.default,
                qeue: OperationQueue = OperationQueue.main)
    {
        self.provider = APNSCertificateProvider(identity: identity, sandbox: sandbox, configuration: configuration, qeue: qeue)
    }
    
    public init(p8: P8, keyId: String, teamId: String, sandbox: Bool = true,
                configuration: URLSessionConfiguration = URLSessionConfiguration.default,
                qeue: OperationQueue = OperationQueue.main)
    {
        self.provider = APNSKeyProvider(p8: p8, keyId: keyId, teamId: teamId, sandbox: sandbox, configuration: configuration, qeue: qeue)
    }
}
