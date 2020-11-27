//
//  SecIdentity+Extensions.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 12.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Security

extension SecIdentity {
    public func name() -> String {
        var result = ""
        var certificate: SecCertificate?
        _ = withUnsafeMutablePointer(to: &certificate) {
            SecIdentityCopyCertificate(self, UnsafeMutablePointer($0))
        }
        
        if let cert = certificate {
            var cfName: CFString?
            _ = withUnsafeMutablePointer(to: &cfName) {
                SecCertificateCopyCommonName(cert, UnsafeMutablePointer($0))
            }
            if let neme = cfName {
                result = neme as String
            } else if let description = SecCertificateCopyLongDescription(nil, cert, nil) {
                result = description as String
            }
        }
        return result
    }
}
