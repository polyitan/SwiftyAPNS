//
//  CertificateProvider.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 11.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Foundation

private enum APNSCertificateProviderError: LocalizedError {
    
    case badUrl
    case encodePayload
    case parseResponce
    case emptyData
    
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

internal final class APNSCertificateProvider: NSObject, APNSSendMessageProtocol {
    
    private var identity: SecIdentity
    private var sesion: URLSession?
    
    public init(identity: SecIdentity, sandbox: Bool = true, configuration: URLSessionConfiguration = URLSessionConfiguration.default, qeue: OperationQueue = OperationQueue.main) {
        self.identity = identity
        super.init()
        self.sesion = URLSession.init(configuration: configuration, delegate: self, delegateQueue: qeue)
    }
    
    public func push<P: Payloadable>(_ notification: APNSNotification<P>, completion: @escaping (Result<APNSResponse, Error>) -> Void) {
        
        let options = notification.options
        var components = URLComponents()
        components.scheme = "https"
        components.host = options.url
        components.path = "/3/device/\(notification.token)"
        guard let url = components.url else {
            completion(.failure(APNSCertificateProviderError.badUrl))
            return
        }
        
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
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
            completion(.failure(APNSCertificateProviderError.encodePayload))
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
                } else {
                    completion(.failure(APNSCertificateProviderError.parseResponce))
                }
            } else {
                completion(.failure(APNSCertificateProviderError.emptyData))
            }
        }
        task?.resume()
    }
}

extension APNSCertificateProvider: URLSessionDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let error = error {
            print("Error: \(error)")
        }
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
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
