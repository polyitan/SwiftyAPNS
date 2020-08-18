//
//  IdentityType.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 11.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Foundation

public enum APNSIdentityType {
    case Invalid
    case Development
    case Production
    case Universal
}

// http://www.apple.com/certificateauthority/Apple_WWDR_CPS
public struct CustomExtensions {
    static let APNSDevelopment = "1.2.840.113635.100.6.3.1"
    static let APNSProduction  = "1.2.840.113635.100.6.3.2"
    static let APNSApple       = "1.2.840.113635.100.6.3.6"
}
