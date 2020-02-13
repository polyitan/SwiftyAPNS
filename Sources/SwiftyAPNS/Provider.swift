//
//  Provider.swift
//  Nint
//
//  Created by Tkachenko Sergey on 5/30/17.
//  Copyright © 2017 Seriy Tkachenko. All rights reserved.
//

import Foundation

public class Provider: NSObject {
    
    private var identity: SecIdentity
    private var sesion: URLSession?
    
    public init (identity: SecIdentity, sandbox: Bool = true, qeue: OperationQueue = OperationQueue.main) {
        self.identity = identity
        
        super.init()
        
        let configuration = URLSessionConfiguration.default
        self.sesion = URLSession.init(configuration: configuration, delegate: self, delegateQueue: qeue)
    }
    
    public func push(_ notification: APNSNotification, completion: @escaping ((URLResponse?, Error?) -> Void)) {
        let url = URL.init(string: "https://api.development.push.apple.com/3/device/\(notification.token)")
        var request = URLRequest.init(url: url!)
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        encoder.outputFormatting = .prettyPrinted
        do {
            let payload = try encoder.encode(notification.payload)
            request.httpBody = payload
        }
        catch {}
        
        let task = self.sesion?.dataTask(with: request) { (data, responce, error) in
            if let error = error {
                completion(nil, error)
            } else if let responce = responce as? HTTPURLResponse, let data = data {
                if let apnsStatus = APNSStatus(code: responce.statusCode),
                    let apnsId = responce.allHeaderFields["apns-id"] as? String
                {
                    print(">>> res >: \(responce)")
                    
                    let reason = try? decoder.decode(APNSError.self, from: data)
                    let apnsResponce = APNSResponse(status: apnsStatus, apnsId: apnsId, reason: reason)
                    print(">>>: \(apnsResponce)")
                    
                    completion(responce, nil)
                }
                else {
                    // error cant parse responce
                }
            }
            else {
                // error empty data
            }
        }
        
        task?.resume()
    }
}

extension Provider: URLSessionDelegate {
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
