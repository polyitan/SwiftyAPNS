//
//  KeyProvider.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 11.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Foundation

internal final class APNSKeyProvider: APNSSendMessageProtocol {
    
    private let p8: P8
    private let jwtEx: APNSJwt
    private let sesion: URLSession
    
    public init(p8: P8, keyId: String, teamId: String, issuedAt: Date, sandbox: Bool = true,
                configuration: URLSessionConfiguration = URLSessionConfiguration.default,
                qeue: OperationQueue = OperationQueue.main)
    {
        self.p8 = p8
        self.jwtEx = APNSJwt(keyId: keyId, teamId: teamId, issuedAt: issuedAt)
        self.sesion = URLSession.init(configuration: configuration, delegate: nil, delegateQueue: qeue)
    }
    
    public func push<P: Payloadable>(_ notification: APNSNotification<P>, completion: @escaping (Result<APNSResponse, Error>) -> Void) {
        
        let options = notification.options
        var components = URLComponents()
        components.scheme = "https"
        components.host = options.url
        components.path = "/3/device/\(notification.token)"
        
        guard let url = components.url else {
            completion(.failure(APNSJwtProviderError.badUrl))
            return
        }
        
        var dataToken: String
        do {
            dataToken = try jwtEx.sign(with: self.p8)
        } catch {
            completion(.failure(error))
            return
        }
        
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json;", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer \(dataToken)", forHTTPHeaderField: "Authorization")
        if let port = options.port {
            components.port = port.rawValue
        }
        request.applyOptions(options)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let payload = try encoder.encode(notification.payload)
            request.httpBody = payload
        } catch {
            completion(.failure(APNSJwtProviderError.encodePayload))
            return
        }
        
        let task = self.sesion.dataTask(with: request) { (data, responce, error) in
            if let error = error {
                completion(.failure(error))
            } else if let responce = responce as? HTTPURLResponse, let data = data {
                if let apnsStatus = APNSStatus(code: responce.statusCode),
                    let apnsId = responce.allHeaderFields["apns-id"] as? String
                {
                    let decoder = JSONDecoder()
                    let reason = try? decoder.decode(APNSError.self, from: data)
                    let apnsResponce = APNSResponse(status: apnsStatus, apnsId: apnsId, reason: reason)
                    completion(.success(apnsResponce))
                } else {
                    completion(.failure(APNSJwtProviderError.parseResponce))
                }
            } else {
                completion(.failure(APNSJwtProviderError.emptyData))
            }
        }
        task.resume()
    }
}
