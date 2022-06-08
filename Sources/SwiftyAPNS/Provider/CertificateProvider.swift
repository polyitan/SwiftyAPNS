//
//  CertificateProvider.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 11.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Foundation

internal final class APNSCertificateProvider: NSObject, APNSSendMessageProtocol {
    
    private var identity: SecIdentity
    private var sesion: URLSession = URLSession.shared
    
    private static let decoder = JSONDecoder()
    
    public init(identity: SecIdentity, sandbox: Bool = true, configuration: URLSessionConfiguration = URLSessionConfiguration.default, qeue: OperationQueue = OperationQueue.main) {
        self.identity = identity
        super.init()
        self.sesion = URLSession.init(configuration: configuration, delegate: self, delegateQueue: qeue)
    }
    
    public func push<P: Payloadable>(_ notification: APNSNotification<P>, completion: @escaping (Result<APNSResponse, Error>) -> Void) {
        do {
            let request = try APNSRequestFactory.makeRequest(notification)
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

extension APNSCertificateProvider: URLSessionDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let error = error {
            print("APNS session error: \(error)")
        }
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        var certificate: SecCertificate?
        _ = withUnsafeMutablePointer(to: &certificate) {
            SecIdentityCopyCertificate(identity, UnsafeMutablePointer($0))
        }
        
        var certificates = [SecCertificate]()
        if let certificate = certificate {
            certificates.append(certificate)
        }
        
        let credential = URLCredential.init(identity: self.identity, certificates: certificates, persistence: .forSession)
        completionHandler(.useCredential, credential)
    }
}
