//
//  SwiftyAPNSTests.swift
//  SwiftyAPNSTests
//

import XCTest
@testable import SwiftyAPNS

enum CertificateConfigKey: String, StringEnum {
    case certPath = "CERT_PATH"
    case certPass = "CERT_PASS"
    case token = "TOKEN"
    case topic = "TOPIC"
}

enum KeyConfigKey: String, StringEnum {
    case keyPath = "KEY_PATH"
    case keyId  = "KEY_ID"
    case teamId = "TEAM_ID"
    case token = "TOKEN"
    case topic = "TOPIC"
}

enum Notification {
    case payload(notificatiuon: APNSNotification<APNSPayload>)
    case payload4(notificatiuon: APNSNotification<CustomPayload4>)
}

final class SwiftyAPNSTests: XCTestCase {
            var provider: APNSProvider! = nil
    private var token: String! = nil
    private var topic: String! = nil
    
    override func setUp() {
        super.setUp()
#if false
        let plistData = readPropertyList("CertificateConfig")
        let pushCertPath = plistData[CertificateConfigKey.certPath]!
        let pushPassword = plistData[CertificateConfigKey.certPass]!
        let PKCS12Data = try! Data(contentsOf: URL(fileURLWithPath: pushCertPath))
        let identity = SecurityTools.identityFromPKCS12(PKCS12Data, password: pushPassword)
        switch identity {
        case .success(let info):
            provider = APNSProvider.init(identity: info.identity)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }

        token = plistData[CertificateConfigKey.token]!
        topic = plistData[CertificateConfigKey.topic]!
#else
        let plistData = readPropertyList("KeyConfig")
        let pushKeyPath = plistData[KeyConfigKey.keyPath]!
        let pushKeyId = plistData[KeyConfigKey.keyId]!
        let pushTeamId = plistData[KeyConfigKey.teamId]!
        let pushKeyData = try! Data(contentsOf: URL(fileURLWithPath: pushKeyPath))
        let pushKeyP8 = String(decoding: pushKeyData, as: UTF8.self)
        provider = APNSProvider.init(p8: pushKeyP8, keyId: pushKeyId, teamId: pushTeamId, issuedAt: Date())
        token = plistData[KeyConfigKey.token]!
        topic = plistData[KeyConfigKey.topic]!
#endif
    }
    
    func testAlertPushExample() {
        let payload = SwiftyAPNSTests.plainAlert
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }
    
    func testAlertWithSubtitlePushExample() {
        let payload = SwiftyAPNSTests.localizedAlert
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }
    
    func testLocalizableAlertPushExample() {
        let payload = SwiftyAPNSTests.localizedAlert5
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }
    
    func testAlertWithCustomActionsPushExample() {
        let payload = SwiftyAPNSTests.localizedAlert6
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }
    
    func testLocalizableAlertPushWithCustomPayloadExample1() {
        let payload = SwiftyAPNSTests.localizedCustomAlert1
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }

    func testLocalizableAlertPushWithCustomPayloadExample2() {
        let payload = SwiftyAPNSTests.localizedCustomAlert2
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }

    func testModifyingContentPushExample() {
        let payload = SwiftyAPNSTests.localizedCustomAlert3
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }
    
    func testBackgroundPushExample() {
        let payload = SwiftyAPNSTests.localizedCustomAlert4
        var options = APNSNotificationOptions.default
        options.type = .background
        options.topic = topic
        //options.environment = .production
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }
    
    func testSendingMultiplePushes() {
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let plainNotification = APNSNotification.init(payload: SwiftyAPNSTests.plainAlert,
                                                      token: token,
                                                      options: options)
        let localizedNotification = APNSNotification.init(payload: SwiftyAPNSTests.localizedAlert5,
                                                          token: token,
                                                          options: options)
        var backgroundOptions = APNSNotificationOptions.default
        backgroundOptions.type = .background
        backgroundOptions.topic = topic
        let backgroundNotification = APNSNotification.init(payload: SwiftyAPNSTests.localizedCustomAlert4,
                                                           token: token,
                                                           options: APNSNotificationOptions.default)
        let notifications: [Notification] = [.payload(notificatiuon: plainNotification),
            .payload(notificatiuon: localizedNotification),
            .payload4(notificatiuon: backgroundNotification)]
        notifications.forEach(visit)
        
//        let notificationss: [APNSNotification] = [plainNotification, localizedNotification, backgroundNotification]
//        notificationss.forEach { notification in
//            print(notification.token)
//        }
// vs
//        let payloads: [Payloadable] = [SwiftyAPNSTests.plainAlert,
//                        SwiftyAPNSTests.localizedAlert5,
//                        SwiftyAPNSTests.localizedCustomAlert4]
//        payloads.forEach { payload in
//            print(payload.aps?.badge ?? 555)
//        }
    }
    
    static var allTests = [
        ("testAlertPushExample", testAlertPushExample),
        ("testAlertWithSubtitlePushExample", testAlertWithSubtitlePushExample),
        ("testLocalizableAlertPushExample", testLocalizableAlertPushExample),
        ("testAlertWithCustomActionsPushExample", testAlertWithCustomActionsPushExample),
        ("testLocalizableAlertPushWithCustomPayloadExample1", testLocalizableAlertPushWithCustomPayloadExample1),
        ("testLocalizableAlertPushWithCustomPayloadExample2", testLocalizableAlertPushWithCustomPayloadExample2),
        ("testModifyingContentPushExample", testModifyingContentPushExample),
        ("testBackgroundPushExample", testBackgroundPushExample)
    ]
}
