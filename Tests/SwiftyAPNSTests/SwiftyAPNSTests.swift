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

final class SwiftyAPNSTests: XCTestCase {
    private var provider: APNSProvider! = nil
    private var token: String! = nil
    private var topic: String! = nil
    
    override func setUp() {
        super.setUp()
        
        let plistData = readPropertyList("CertificateConfig")
        let pushCertPath = plistData[CertificateConfigKey.certPath]!
        let pushPassword = plistData[CertificateConfigKey.certPass]!
        let identity = identityFrom(pushCertPath, password: pushPassword)!
        provider = APNSProvider.init(identity: identity)
        token = plistData[CertificateConfigKey.token]!
        topic = plistData[CertificateConfigKey.topic]!
    }
    
    func testAlertPushExample() {
        let payload = APNSPayload(alert: APSAlert.plain(plain: "Test Alert notification."))
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }
    
    func testAlertWithSubtitlePushExample() {
        var alert = APSLocalizedAlert()
        alert.title = "Test"
        alert.subtitle = "Alert notification"
        alert.body = "with subtitle."
        let payload = APNSPayload(alert: APSAlert.localized(alert: alert))
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }
    
    func testLocalizableAlertPushExample() {
        var alert = APSLocalizedAlert()
        alert.locKey = "REQUEST_FORMAT"
        alert.locArgs = ["Jenna", "Frank"]
        let payload = APNSPayload(alert: APSAlert.localized(alert: alert))
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }
    
    func testAlertWithCustomActionsPushExample() {
        var alert = APSLocalizedAlert()
        alert.body = "Test Alert with custom action notification."
        let payload = APNSPayload(alert: APSAlert.localized(alert: alert), badge: 1, sound: "default.wav", category: "MESSAGE_CATEGORY")
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }
    
    func testLocalizableAlertPushWithCustomPayloadExample1() {
        var alert = APSLocalizedAlert()
        alert.body = "Test Alert with custom payload notification."
        let payload = CustomPayload1(alert: APSAlert.localized(alert: alert), badge: 1, sound: "default.wav", category: "MESSAGE_CATEGORY", acme1: "bar", acme2: 42)
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }
    
    func testLocalizableAlertPushWithCustomPayloadExample2() {
        var alert = APSLocalizedAlert()
        alert.body = "Test Alert with custom payload notification."
        let payload = CustomPayload2(alert: APSAlert.localized(alert: alert), badge: 1, sound: "default.wav", category: "MESSAGE_CATEGORY", acme1: ["bang", "whiz"])
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }
    
    func testBackgroundPushExample() {
        let payload = CustomPayload1(acme1: "bar", acme2: 42)
        var options = APNSNotificationOptions.default
        options.type = .alert//.voip
        options.topic = topic
        //options.environment = .production
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }
    
    func testModifyingContentPushExample() {
        var alert = APSLocalizedAlert()
        alert.body = "Test mutable conten payload notification."
        let payload = CustomPayload3(alert: APSAlert.localized(alert: alert), badge: 1, sound: "default.wav", category: "MESSAGE_CATEGORY", encrypted: "Ω^¬%gq∞NÿÒQùw")
        var options = APNSNotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification)
    }

    static var allTests = [
        ("testAlertPushExample", testAlertPushExample),
        ("testAlertWithSubtitlePushExample", testAlertWithSubtitlePushExample),
        ("testLocalizableAlertPushExample", testLocalizableAlertPushExample),
        ("testAlertWithCustomActionsPushExample", testAlertWithCustomActionsPushExample),
        ("testLocalizableAlertPushWithCustomPayloadExample1", testLocalizableAlertPushWithCustomPayloadExample1),
        ("testLocalizableAlertPushWithCustomPayloadExample2", testLocalizableAlertPushWithCustomPayloadExample2),
        ("testBackgroundPushExample", testBackgroundPushExample),
        ("testModifyingContentPushExample", testModifyingContentPushExample)
    ]
}

extension SwiftyAPNSTests {
    private func sendPushNotification(_ notification: APNSNotification) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encoded = try! encoder.encode(notification.payload)
        print(String(data: encoded, encoding: .utf8)!)
        
        let expect = self.expectation(description: "APNSExpectation")
        provider.push(notification) { (result) in
            switch(result) {
            case .success(let responce):
                if let error = responce.reason {
                    XCTFail(error.description)
                } else {
                    expect.fulfill()
                }
            case .failure(let error):
                if let error = error as? APNSProviderError {
                    XCTFail(error.description)
                } else {
                    XCTFail(error.localizedDescription)
                }
            }
        }
        
        self.waitForExpectations(timeout: 5.0) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    private func readPropertyList(_ name: String) -> [String: String] {
        var propertyListFormat = PropertyListSerialization.PropertyListFormat.xml
        let bundle = Bundle(for: type(of: self))
        let plistPath = bundle.path(forResource: name, ofType: "plist")!
        let plistXML = FileManager.default.contents(atPath: plistPath)!
        let plistData = try! PropertyListSerialization.propertyList(from: plistXML,
                                                                    options: .mutableContainersAndLeaves,
                                                                    format: &propertyListFormat) as! [String: String]
        return plistData
    }
    
    private func identityFrom(_ path: String, password: String) -> SecIdentity? {
        let url = URL(fileURLWithPath: path)
        print("\(url)")
        let PKCS12Data = try? Data(contentsOf: url)
        print("\(String(describing: PKCS12Data))")
        let PKCS12options: NSDictionary = [kSecImportExportPassphrase as NSString: password]
        
        var items: CFArray?
        let status: OSStatus = SecPKCS12Import(PKCS12Data! as NSData, PKCS12options, &items)
        guard status == errSecSuccess else {
            XCTFail("Fail"); return nil
        }
        
        guard items != nil else {
            XCTFail("Fail"); return nil
        }
        
        guard let dictArray = items as? [[String: AnyObject]] else {
            XCTFail("Fail"); return nil
        }
        
        func f<T>(key: CFString) -> T? {
            for d in dictArray {
                if let v = d[key as String] as? T {
                    return v
                }
            }
            return nil
        }
        
        guard let identity: SecIdentity = f(key: kSecImportItemIdentity) else {
            XCTFail("Fail"); return nil
        }
        
        return identity
    }
}
