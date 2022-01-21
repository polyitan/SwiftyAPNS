//
//  InterruptionLevel.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 21.01.2022.
//  Copyright © 2022 Sergii Tkachenko. All rights reserved.
//

/// The value indicates the importance and delivery timing of notification..
public enum APSInterruptionLevel: Encodable {
    case passive
    case active
    case timeSensitive
    case critical
    
    /// Keys that uses for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case passive
        case active
        case timeSensitive = "time-sensitive"
        case critical
    }
}
