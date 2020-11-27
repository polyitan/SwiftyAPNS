//
//  SecurityTools.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 11.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Foundation

public class SecurityTools {
    
    public typealias IdentityInfo = (identity: SecIdentity, label: String)
    public typealias Identity = Result<IdentityInfo, IdentityInfoReadError>
    
    public enum IdentityInfoReadError: String, Error {
        case auth    = "Incorrect password was supplied, or data in the container is damaged"
        case decode  = "The blob can't be read or it is malformed"
        case unknown = "An error happen"
    }
    
    public static func identityFromPKCS12(_ data: Data, password: String) -> Identity {
        var items: CFArray?
        let options: NSDictionary = [kSecImportExportPassphrase as NSString:password]
        let status: OSStatus = SecPKCS12Import(data as NSData, options, &items)
        
        guard status == errSecSuccess else {
            if status == errSecAuthFailed {
                return .failure(.auth)
            }
            else if status == errSecDecode {
                return .failure(.decode)
            }
            return .failure(.unknown)
        }
        
        guard let _ = items else {
            return .failure(.unknown)
        }
        
        guard let dictArray = items as? [[String: AnyObject]] else {
            return .failure(.unknown)
        }
        
        func f<T>(key: CFString) -> T? {
            for d in dictArray {
                if let v = d[key as String] as? T {
                    return v
                }
            }
            return nil
        }
        
        guard let identity: SecIdentity = f(key: kSecImportItemIdentity),
            let label: String = f(key: kSecImportItemLabel) else {
            return .failure(.unknown)
        }
        
        return .success(IdentityInfo(identity: identity, label: label))
    }
    
    public static func gunc(identity: SecIdentity) -> [String: AnyObject] {
        var certificate: SecCertificate?
        _ = withUnsafeMutablePointer(to: &certificate) {
            SecIdentityCopyCertificate(identity, UnsafeMutablePointer($0))
        }
        if let cert = certificate {
            let keys = [CustomExtensions.APNSDevelopment, CustomExtensions.APNSProduction, CustomExtensions.APNSApple]
            return SecCertificateCopyValues(cert, keys as CFArray, nil) as! [String: AnyObject]
        }
        return [:]
    }

    public static func getType(identity: SecIdentity) -> APNSIdentityType {
        let values = gunc(identity: identity)
        if let _ = values[CustomExtensions.APNSDevelopment], let _ = values[CustomExtensions.APNSProduction] {
            return .Universal;
        } else if let _ = values[CustomExtensions.APNSDevelopment] {
            return .Development;
        } else if let _ = values[CustomExtensions.APNSProduction] {
            return .Production;
        }
        return .Invalid;
    }

    public static func getTopics(identity: SecIdentity) -> [String] {
        var results = [String]()
        let values = gunc(identity: identity)
        if  let _ = values[CustomExtensions.APNSDevelopment],
            let _ = values[CustomExtensions.APNSProduction],
            let content = values[CustomExtensions.APNSApple] {
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
}
