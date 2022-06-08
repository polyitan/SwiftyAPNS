//
//  ProviderError.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 08.06.2022.
//  Copyright © 2022 Sergii Tkachenko. All rights reserved.
//

import Foundation

public enum APNSProviderError {
    
    case badUrl
    case encodePayload
    case parseResponce
    case emptyData
}

extension APNSProviderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badUrl: return
            "The url was invalid"
        case .encodePayload: return
            "Can't encode payload"
        case .parseResponce: return
            "Can't parse responce"
        case .emptyData: return
            "Empty data"
        }
    }
}
