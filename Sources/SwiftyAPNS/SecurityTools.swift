//
//  SecurityTools.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 11.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Foundation

public final class SecurityTools {
    
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
            } else if status == errSecDecode {
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
}
