//
//  Jwt.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 09.12.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Foundation

internal enum APNSJwtProviderError {
    
    case badUrl
    case encodePayload
    case parseResponce
    case emptyData
}

extension APNSJwtProviderError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badUrl: return
            "The url was invalid"
        case .encodePayload: return
            "Can't encode payload"
        case .parseResponce: return
            "Can't parse responce"
        case .emptyData: return
            "Empty data"
        }
    }
}

/// The token that you include with your notification requests uses the JSON Web Token (JWT) specification
internal struct APNSJwt: Codable {
    
    private struct APNSJwtHeader: Codable {
        /// The encryption algorithm you used to encrypt the token.
        /// APNs supports only the ES256 algorithm,
        /// so set the value of this key to ES256.
        public let algorithm: String = "ES256"
        
        /// The 10-character Key ID you obtained from your developer account
        public let keyId: String
        
        /// Keys that uses for encoding and decoding.
        private enum CodingKeys: String, CodingKey {
            case algorithm = "alg"
            case keyId = "kid"
        }
    }
    
    private struct APNSJwtPayload: Codable {
        /// The issuer key, the value for which is the 10-character Team ID
        public let teamId: String
        
        /// The “issued at” time, whose value indicates the time at which this JSON token was generated
        public let issuedAt: Int
        
        /// Keys that uses for encoding and decoding.
        private enum CodingKeys: String, CodingKey {
            case teamId = "iss"
            case issuedAt = "iat"
        }
    }
    
    private let header: APNSJwtHeader
    private let payload: APNSJwtPayload
    
    private static let encoder = JSONEncoder()
    
    public init (keyId: String, teamId: String, issuedAt: Date) {
        let iat = Int(issuedAt.timeIntervalSince1970.rounded())
        self.header = APNSJwtHeader(keyId: keyId)
        self.payload = APNSJwtPayload(teamId: teamId, issuedAt: iat)
    }

    /// Sign digest with P8(PEM) string.
    public func sign(with p8: String) throws -> String {
        let digest = try self.digest()
        let asn1 = try p8.toASN1()
        let keyData = try asn1.toECKeyData()
        let privateKey = try keyData.toPrivateKey()
        let signature = try privateKey.es256Sign(digest: digest)
        let token = "\(digest).\(signature)"
        return token
    }
    
    /// Combine header and payload as digest for signing.
    private func digest() throws -> String {
        let headerString = try JSONEncoder().encode(header.self).base64EncodedURLString()
        let payloadString = try JSONEncoder().encode(payload.self).base64EncodedURLString()
        return "\(headerString).\(payloadString)"
    }
}
