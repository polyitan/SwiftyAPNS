//
//  SecIdentity+Extensions.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 12.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Security

#if TARGET_OS_OSX
public extension SecIdentity {
    func name() -> String {
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

    func type() -> APNSIdentityType {
        let values = gunc()
        if let _ = values[CustomExtensions.APNSDevelopment], let _ = values[CustomExtensions.APNSProduction] {
            return .Universal;
        } else if let _ = values[CustomExtensions.APNSDevelopment] {
            return .Development;
        } else if let _ = values[CustomExtensions.APNSProduction] {
            return .Production;
        }
        return .Invalid;
    }

    func topics() -> [String] {
        var results = [String]()
        let values = gunc()
        if  let _ = values[CustomExtensions.APNSDevelopment],
            let _ = values[CustomExtensions.APNSProduction],
            let content = values[CustomExtensions.APNSApple] as? [String: Any] {
            if let topicInfo = content["value"] as? [[String: Any]] {
                for itemInfo in topicInfo {
                    if let topic = itemInfo["value"] as? String, topic != "No" {
                        results.append(topic)
                    }
                }
            }
        }
        return results
    }
    
    private func gunc() -> [String: AnyObject] {
        var certificate: SecCertificate?
        _ = withUnsafeMutablePointer(to: &certificate) {
            SecIdentityCopyCertificate(self, UnsafeMutablePointer($0))
        }
        if let cert = certificate {
            let keys = [CustomExtensions.APNSDevelopment,
                        CustomExtensions.APNSProduction,
                        CustomExtensions.APNSApple]
            return SecCertificateCopyValues(cert, keys as CFArray, nil) as! [String: AnyObject]
        }
        return [:]
    }
}
#endif
