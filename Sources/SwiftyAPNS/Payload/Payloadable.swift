//
//  Payloadable.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 21.01.2022.
//  Copyright © 2022 Sergii Tkachenko. All rights reserved.
//

public protocol Payloadable: Encodable {
    var aps: APS? { get set }
}
