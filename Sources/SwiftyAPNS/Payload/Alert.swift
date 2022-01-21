//
//  Alert.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 21.01.2022.
//  Copyright © 2022 Sergii Tkachenko. All rights reserved.
//

/// Can specify a string or a dictionary as the value of alert.
public enum APSAlert: Encodable {
    case plain(plain: String)
    case localized(alert: APSLocalizedAlert)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .plain(let text):
            try container.encode(text)
        case .localized(let alert):
            try container.encode(alert)
        }
    }
    
    /// Keys that uses for encoding and decoding.
    private enum CodingKeys: String, CodingKey {
        case alert
    }
}
