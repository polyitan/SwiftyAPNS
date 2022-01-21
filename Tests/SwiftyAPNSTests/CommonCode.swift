//
//  CommonCode.swift
//  SwiftyAPNSTests
//

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
