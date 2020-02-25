//
//  Provider.swift
//  SwiftyAPNS
//
//  Created by Tkachenko Sergii on 5/30/17.
//  Copyright © 2017 Sergii Tkachenko. All rights reserved.
//

import Foundation

public enum APNSProviderError: Error {
    
    case BadUrl
    case EncodePayload
    case ParseResponce
    case EmptyData
    
    public var description: String {
        switch self {
        case .BadUrl: return
            "The url was invalid"
        case .EncodePayload: return
            "Can't encode payload"
        case .ParseResponce: return
            "Can't parse responce"
        case .EmptyData: return
            "Empty data"
        }
    }
}

public class APNSProvider: NSObject {
    
    private var identity: SecIdentity
    private var sesion: URLSession?
    
    public init(identity: SecIdentity, sandbox: Bool = true, configuration: URLSessionConfiguration = URLSessionConfiguration.default, qeue: OperationQueue = OperationQueue.main) {
        self.identity = identity
        super.init()
        self.sesion = URLSession.init(configuration: configuration, delegate: self, delegateQueue: qeue)
    }
    
    public func push(_ notification: APNSNotification, completion: @escaping (Result<APNSResponse, Error>) -> Void) {
        
        let options = notification.options
        var components = URLComponents()
        components.scheme = "https"
        components.host = options.url
        components.path = "/3/device/\(notification.token)"
        if let port = options.port {
            components.port = port.rawValue
        }
        guard let url = components.url else {
            completion(.failure(APNSProviderError.BadUrl))
            return
        }
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        
        if let type = options.type {
            request.setValue("\(type)", forHTTPHeaderField: "apns-push-type")
        }
        if let id = options.id {
            request.setValue("\(id)", forHTTPHeaderField: "apns-id")
        }
        if let expiration = options.expiration {
            request.setValue("\(expiration)", forHTTPHeaderField: "apns-expiration")
        }
        if let priority = options.priority {
            request.setValue("\(priority.rawValue)", forHTTPHeaderField: "apns-priority")
        }
        if let topic = options.topic {
            request.setValue("\(topic)", forHTTPHeaderField: "apns-topic")
        }
        if let collapseId = options.collapseId {
            request.setValue("\(collapseId)", forHTTPHeaderField: "apns-collapse-id")
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let payload = try encoder.encode(notification.payload)
            request.httpBody = payload
        }
        catch {
            completion(.failure(APNSProviderError.EncodePayload))
            return
        }
        
        let task = self.sesion?.dataTask(with: request) { (data, responce, error) in
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
                }
                else {
                    completion(.failure(APNSProviderError.ParseResponce))
                }
            }
            else {
                completion(.failure(APNSProviderError.EmptyData))
            }
        }
        task?.resume()
    }
}

extension APNSProvider: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let error = error {
            print("Error: \(error)")
        }
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        var certificate: SecCertificate?
        _ = withUnsafeMutablePointer(to: &certificate) {
            SecIdentityCopyCertificate(self.identity, UnsafeMutablePointer($0))
        }
        
        var certificates = [SecCertificate]()
        if let cert = certificate {
            certificates.append(cert)
        }
        
        let cred = URLCredential.init(identity: self.identity, certificates: certificates, persistence: .forSession)
        completionHandler(.useCredential, cred)
    }
}
