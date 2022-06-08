//
//  KeyProvider.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 11.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Foundation

internal final class APNSKeyProvider: APNSSendMessageProtocol {
    
    private let token: APNSBearerToken
    private let sesion: URLSession
    
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    public init(p8: P8, keyId: String, teamId: String, sandbox: Bool = true,
                configuration: URLSessionConfiguration = URLSessionConfiguration.default,
                qeue: OperationQueue = OperationQueue.main)
    {
        self.token = APNSBearerToken(p8: p8, keyId: keyId, teamId: teamId)
        self.sesion = URLSession.init(configuration: configuration, delegate: nil, delegateQueue: qeue)
    }
    
    public func push<P: Payloadable>(_ notification: APNSNotification<P>, completion: @escaping (Result<APNSResponse, Error>) -> Void) {
        do {
            var request = try APNSRequestFactory.makeRequest(notification)
            let dataToken = try token.generateIfExpired()
            request.setValue("application/json;", forHTTPHeaderField: "Content-Type")
            request.setValue("bearer \(dataToken)", forHTTPHeaderField: "Authorization")
            let task = self.sesion.dataTask(with: request) { (data, responce, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let responce = responce as? HTTPURLResponse, let data = data {
                    if let apnsStatus = APNSStatus(code: responce.statusCode),
                        let apnsId = responce.allHeaderFields["apns-id"] as? String
                    {
                        let reason = try? Self.decoder.decode(APNSError.self, from: data)
                        let apnsResponce = APNSResponse(status: apnsStatus, apnsId: apnsId, reason: reason)
                        completion(.success(apnsResponce))
                    } else {
                        completion(.failure(APNSProviderError.parseResponce))
                    }
                } else {
                    completion(.failure(APNSProviderError.emptyData))
                }
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
