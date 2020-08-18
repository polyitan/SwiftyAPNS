//
//  SecKey+Extensions.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 12.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Foundation
import CommonCrypto

public typealias ECPrivateKey = SecKey

public enum ECPrivateKeyError: LocalizedError {
    
    case digestDataCorruption
    case keyNotSupportES256Signing
    
    public var errorDescription: String? {
        switch self {
        case .digestDataCorruption:
            return "Internal error."
        case .keyNotSupportES256Signing:
            return "The private key does not support ES256 signing"
        }
    }
}

extension ECPrivateKey {
    public func es256Sign(digest: String) throws -> String {
        guard let message = digest.data(using: .utf8) else {
            throw ECPrivateKeyError.digestDataCorruption
        }

        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256((message as NSData).bytes, CC_LONG(message.count), &hash)
        
        let digestData = Data(hash)
        let algorithm = SecKeyAlgorithm.ecdsaSignatureDigestX962SHA256
        guard SecKeyIsAlgorithmSupported(self, .sign, algorithm) else {
            throw ECPrivateKeyError.keyNotSupportES256Signing
        }

        var error: Unmanaged<CFError>? = nil
        guard let signature = SecKeyCreateSignature(self, algorithm, digestData as CFData, &error) else {
            throw error!.takeRetainedValue()
        }

        let rawSignature = try (signature as ASN1).toRawSignature()
        return rawSignature.base64EncodedURLString()
    }
}
