//
//  File.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 21.01.2022.
//  Copyright © 2022 Sergii Tkachenko. All rights reserved.
//

internal protocol APNSSendMessageProtocol {
    func push<P: Payloadable>(_ notification: APNSNotification<P>) async throws -> APNSResponse
}
