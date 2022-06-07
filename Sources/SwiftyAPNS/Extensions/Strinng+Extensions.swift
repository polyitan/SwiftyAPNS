//
//  Strinng+Extensions.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 18.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Foundation

public typealias P8 = String

internal enum P8Error {
    
    case invalidP8
}

extension P8Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidP8:
            return "The .p8 string has invalid format."
        }
    }
}

internal extension P8 {
    /// Convert PEM format .p8 file to DER-encoded ASN.1 data
    func toASN1() throws -> ASN1 {
        let base64 = self
            .split(separator: "\n")
            .filter({ $0.hasPrefix("-----") == false })
            .joined(separator: "")
        guard let asn1 = Data(base64Encoded: base64) else {
            throw P8Error.invalidP8
        }
        return asn1
    }
}
