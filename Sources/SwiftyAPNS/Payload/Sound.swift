//
//  Sound.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 21.01.2022.
//  Copyright © 2022 Sergii Tkachenko. All rights reserved.
//

/// Can specify a string or a dictionary as the value of alert.
public enum APSSound: Encodable {
    case regular(sound: String)
    case critical(info: APSSoundInfo)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .regular(let sound):
            try container.encode(sound)
        case .critical(let info):
            try container.encode(info)
        }
    }
    
    /// Keys that uses for encoding and decoding.
    private enum CodingKeys: String, CodingKey {
        case sound
    }
}
