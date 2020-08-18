//
//  Provider.swift
//  SwiftyAPNS
//
//  Created by Tkachenko Sergii on 5/30/17.
//  Copyright © 2017 Sergii Tkachenko. All rights reserved.
//

import Foundation

public protocol APNSSendMessageProtocol {
    func push(_ notification: APNSNotification, completion: @escaping (Result<APNSResponse, Error>) -> Void)
}

public class APNSProvider {
    private var provider: APNSSendMessageProtocol
    
    public init(identity: SecIdentity, sandbox: Bool = true,
                configuration: URLSessionConfiguration = URLSessionConfiguration.default,
                qeue: OperationQueue = OperationQueue.main)
    {
        self.provider = APNSCertificateProvider(identity: identity, sandbox: sandbox, configuration: configuration, qeue: qeue)
    }
    
    public init(p8: P8, keyId: String, teamId: String, issuedAt: Date, sandbox: Bool = true,
                configuration: URLSessionConfiguration = URLSessionConfiguration.default,
                qeue: OperationQueue = OperationQueue.main)
    {
        self.provider = APNSKeyProvider(p8: p8, keyId: keyId, teamId: teamId, issuedAt: issuedAt, sandbox: sandbox, configuration: configuration, qeue: qeue)
    }
    
    public func push(_ notification: APNSNotification, completion: @escaping (Result<APNSResponse, Error>) -> Void) {
        self.provider.push(notification, completion: completion)
    }
}
