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
    
    private lazy var defaultOptions: APNSNotificationOptions = {
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        return options
    }()
    private lazy var backgroundOptions: APNSNotificationOptions = {
        var options = APNSNotificationOptions.default
        options.type = .background
        options.topic = topic
        return options
    }()
    
    private lazy var alertPushExample: APNSNotification<APNSPayload> = {
        let payload = SwiftyAPNSTests.plainAlert
        let notification = APNSNotification.init(payload: payload, token: token, options: defaultOptions)
        return notification
    }()
    private lazy var alertWithSubtitlePushExample: APNSNotification<APNSPayload> = {
        let payload = SwiftyAPNSTests.localizedAlert
        let notification = APNSNotification.init(payload: payload, token: token, options: defaultOptions)
        return notification
    }()
    private lazy var localizableAlertPushExample: APNSNotification<APNSPayload> = {
        let payload = SwiftyAPNSTests.localizedAlert5
        let notification = APNSNotification.init(payload: payload, token: token, options: defaultOptions)
        return notification
    }()
    private lazy var alertWithCustomActionsPushExample: APNSNotification<APNSPayload> = {
        let payload = SwiftyAPNSTests.localizedAlert6
        let notification = APNSNotification.init(payload: payload, token: token, options: defaultOptions)
        return notification
    }()
    private lazy var localizableAlertPushWithCustomPayloadExample1: APNSNotification<CustomPayload1> = {
        let payload = SwiftyAPNSTests.localizedCustomAlert1
        let notification = APNSNotification.init(payload: payload, token: token, options: defaultOptions)
        return notification
    }()
    private lazy var localizableAlertPushWithCustomPayloadExample2: APNSNotification<CustomPayload2> = {
        let payload = SwiftyAPNSTests.localizedCustomAlert2
        let notification = APNSNotification.init(payload: payload, token: token, options: defaultOptions)
        return notification
    }()
    private lazy var modifyingContentPushExample: APNSNotification<CustomPayload3> = {
        let payload = SwiftyAPNSTests.localizedCustomAlert3
        let notification = APNSNotification.init(payload: payload, token: token, options: defaultOptions)
        return notification
    }()
    private lazy var backgroundPushExample: APNSNotification<CustomPayload4> = {
        let payload = SwiftyAPNSTests.localizedCustomAlert4
        let notification = APNSNotification.init(payload: payload, token: token, options: backgroundOptions)
        return notification
    }()
    
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
        provider = APNSProvider.init(p8: pushKeyP8, keyId: pushKeyId, teamId: pushTeamId)
        token = plistData[KeyConfigKey.token]!
        topic = plistData[KeyConfigKey.topic]!
#endif
    }
    
    func testAlertPushExample() async throws {
        try await sendPushNotification(alertPushExample)
    }
    
    func testAlertWithSubtitlePushExample() async throws {
        try await sendPushNotification(alertWithSubtitlePushExample)
    }
    
    func testLocalizableAlertPushExample() async throws {
        try await sendPushNotification(localizableAlertPushExample)
    }
    
    func testAlertWithCustomActionsPushExample() async throws {
        try await sendPushNotification(alertWithCustomActionsPushExample)
    }
    
    func testLocalizableAlertPushWithCustomPayloadExample1() async throws {
        try await sendPushNotification(localizableAlertPushWithCustomPayloadExample1)
    }

    func testLocalizableAlertPushWithCustomPayloadExample2() async throws {
        try await sendPushNotification(localizableAlertPushWithCustomPayloadExample2)
    }

    func testModifyingContentPushExample() async throws {
        try await sendPushNotification(modifyingContentPushExample)
    }
    
    func testBackgroundPushExample() async throws {
        try await sendPushNotification(backgroundPushExample)
    }
    
    func testSendingMultiplePushes() async throws {
        let notifications: [Notification] = [
            .payload(notificatiuon: alertPushExample),
            .payload(notificatiuon: alertWithSubtitlePushExample),
            .payload(notificatiuon: localizableAlertPushExample),
            .payload(notificatiuon: alertWithCustomActionsPushExample),
            .payload4(notificatiuon: backgroundPushExample)
        ]
        for notification in notifications {
            try await visit(notification: notification)
        }
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
