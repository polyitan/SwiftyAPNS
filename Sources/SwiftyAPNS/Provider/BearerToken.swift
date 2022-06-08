//
//  APNSBearerToken.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 08.06.2022.
//  Copyright © 2022 Sergii Tkachenko. All rights reserved.
//

import Foundation

internal class APNSBearerToken {
    
    private let keyId: String
    private let teamId: String
    private var issuedAt: Date
    
    private let p8: P8
    private var jwtEx: APNSJwt
    
    private var bearer: String?
    private var expired: Bool {
        return Date().timeIntervalSince(issuedAt) >= TimeInterval(60 * 59)
    }
    
    init(p8: P8, keyId: String, teamId: String, issuedAt: Date = Date()) {
        self.p8 = p8; self.keyId = keyId; self.teamId = teamId; self.issuedAt = issuedAt
        self.jwtEx = APNSJwt(keyId: keyId, teamId: teamId, issuedAt: issuedAt)
    }
    
    func generateIfExpired() throws -> String {
        if bearer == nil || expired {
            try generate()
        }
        guard let bearer = bearer else {
            throw APNSProviderError.emptyData
        }
        return bearer
    }
    
    private func generate() throws {
        issuedAt = Date()
        jwtEx = APNSJwt(keyId: keyId, teamId: teamId, issuedAt: issuedAt)
        bearer = try jwtEx.sign(with: p8)
    }
}
