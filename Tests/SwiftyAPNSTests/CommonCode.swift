//
//  CommonCode.swift
//  SwiftyAPNSTests
//

import Foundation
@testable import SwiftyAPNS

protocol StringEnum {
    var rawValue: String { get }
}

extension Dictionary {
    subscript(enumKey: StringEnum) -> Value? {
        get {
            if let key = enumKey.rawValue as? Key {
                return self[key]
            }
            return nil
        }
        set {
            if let key = enumKey.rawValue as? Key {
                self[key] = newValue
            }
        }
    }
}

private func gunc(identity: SecIdentity) -> [String: AnyObject] {
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

public func getType(identity: SecIdentity) -> APNSIdentityType {
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

public func getTopics(identity: SecIdentity) -> [String] {
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
