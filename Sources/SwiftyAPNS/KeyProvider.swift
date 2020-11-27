//
//  KeyProvider.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 11.08.2020.
//  Copyright © 2020 Sergii Tkachenko. All rights reserved.
//

import Foundation

private enum APNSJwtProviderError: LocalizedError {
    
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

/// The token that you include with your notification requests uses the JSON Web Token (JWT) specification
private struct APNSJwt: Codable {
    
    private struct APNSJwtHeader: Codable {
        /// The encryption algorithm you used to encrypt the token.
        /// APNs supports only the ES256 algorithm,
        /// so set the value of this key to ES256.
        public let algorithm: String = "ES256"
        
        /// The 10-character Key ID you obtained from your developer account
        public let keyId: String
        
        /// Keys that uses for encoding and decoding.
        private enum CodingKeys: String, CodingKey {
            case algorithm = "alg"
            case keyId = "kid"
        }
    }
    
    private struct APNSJwtPayload: Codable {
        /// The issuer key, the value for which is the 10-character Team ID
        public let teamId: String
        
        /// The “issued at” time, whose value indicates the time at which this JSON token was generated
        public let issuedAt: Int
        
        /// Keys that uses for encoding and decoding.
        private enum CodingKeys: String, CodingKey {
            case teamId = "iss"
            case issuedAt = "iat"
        }
    }
    
    private let header: APNSJwtHeader
    private let payload: APNSJwtPayload
    
    private static let encoder = JSONEncoder()
    
    public init (keyId: String, teamId: String, issuedAt: Date) {
        let iat = Int(issuedAt.timeIntervalSince1970.rounded())
        self.header = APNSJwtHeader(keyId: keyId)
        self.payload = APNSJwtPayload(teamId: teamId, issuedAt: iat)
    }
    
    /// Combine header and payload as digest for signing.
    private func digest() throws -> String {
        let headerString = try JSONEncoder().encode(header.self).base64EncodedURLString()
        let payloadString = try JSONEncoder().encode(payload.self).base64EncodedURLString()
        return "\(headerString).\(payloadString)"
    }

    /// Sign digest with P8(PEM) string.
    fileprivate func sign(with p8: String) throws -> String {
        let digest = try self.digest()
        let asn1 = try p8.toASN1()
        let keyData = try asn1.toECKeyData()
        let privateKey = try keyData.toPrivateKey()
        let signature = try privateKey.es256Sign(digest: digest)
        let token = "\(digest).\(signature)"
        return token
    }
}

open class APNSKeyProvider: APNSSendMessageProtocol {
    
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
    
    public func push(_ notification: APNSNotification, completion: @escaping (Result<APNSResponse, Error>) -> Void) {
        
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
