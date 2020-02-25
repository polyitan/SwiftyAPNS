import XCTest
@testable import SwiftyAPNS

public class CustomPayload1: Payload {

    public let acme1: String
    public let acme2: Int

    public init (alert: APSAlert?, badge: Int?, sound: String?, category: String?, acme1: String, acme2: Int) {
        self.acme1 = acme1
        self.acme2 = acme2
        super.init(alert: alert, badge: badge, sound: sound, contentAvailable: (alert == nil) ? 1 : nil, mutableContent: nil, category: category, threadId: nil)
    }
    
    public init (acme1: String, acme2: Int) {
        self.acme1 = acme1
        self.acme2 = acme2
        super.init(alert: nil, badge: nil, sound: nil, contentAvailable: 1, mutableContent: nil, category: nil, threadId: nil)
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(acme1, forKey: .acme1)
        try container.encode(acme2, forKey: .acme2)
    }

    private enum CodingKeys: String, CodingKey {
        case acme1
        case acme2
    }
}

public class CustomPayload2: Payload {

    public let acme1: [String]

    public init (alert: APSAlert?, badge: Int?, sound: String?, category: String?, acme1: [String]) {
        self.acme1 = acme1
        super.init(alert: alert, badge: badge, sound: sound, contentAvailable: (alert == nil) ? 1 : nil, mutableContent: nil, category: category, threadId: nil)
    }

    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(acme1, forKey: .acme1)
    }

    private enum CodingKeys: String, CodingKey {
        case acme1
    }
}

public class CustomPayload3: Payload {

    public let encrypted: String

    public init (alert: APSAlert?, badge: Int?, sound: String?, category: String?, encrypted: String) {
        self.encrypted = encrypted
        super.init(alert: alert, badge: badge, sound: sound, contentAvailable: nil, mutableContent: 1, category: category, threadId: nil)
    }

    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(encrypted, forKey: .encrypted)
    }

    private enum CodingKeys: String, CodingKey {
        case encrypted
    }
}

final class SwiftyAPNSTests: XCTestCase {
    let token = "0ab0aaff76ab302ecba6e28fddcc457c8e9c12f6cff68d9fecdce2b6df1f1177"
    let topic = "com.push.example"
    let pushCertPath = "./push_cert.p12"
    let pushPassword = "secure"
    
    func testAlertPushExample() {
        let payload = Payload(alert: APSAlert.plain(plain: "Test Alert notification."))
        var options = NotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification, path: pushCertPath, password: pushPassword)
    }
    
    func testAlertWithSubtitlePushExample() {
        var alert = APSLocalizedAlert()
        alert.title = "Test"
        alert.subtitle = "Alert notification"
        alert.body = "with subtitle."
        let payload = Payload(alert: APSAlert.localized(alert: alert))
        var options = NotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification, path: pushCertPath, password: pushPassword)
    }
    
    func testLocalizableAlertPushExample() {
        var alert = APSLocalizedAlert()
        alert.locKey = "REQUEST_FORMAT"
        alert.locArgs = ["Jenna", "Frank"]
        let payload = Payload(alert: APSAlert.localized(alert: alert))
        var options = NotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification, path: pushCertPath, password: pushPassword)
    }
    
    func testAlertWithCustomActionsPushExample() {
        var alert = APSLocalizedAlert()
        alert.body = "Test Alert with custom action notification."
        let payload = Payload(alert: APSAlert.localized(alert: alert), badge: 1, sound: "default.wav", category: "MESSAGE_CATEGORY")
        var options = NotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification, path: pushCertPath, password: pushPassword)
    }
    
    func testLocalizableAlertPushWithCustomPayloadExample1() {
        var alert = APSLocalizedAlert()
        alert.body = "Test Alert with custom payload notification."
        let payload = CustomPayload1(alert: APSAlert.localized(alert: alert), badge: 1, sound: "default.wav", category: "MESSAGE_CATEGORY", acme1: "bar", acme2: 42)
        var options = NotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification, path: pushCertPath, password: pushPassword)
    }
    
    func testLocalizableAlertPushWithCustomPayloadExample2() {
        var alert = APSLocalizedAlert()
        alert.body = "Test Alert with custom payload notification."
        let payload = CustomPayload2(alert: APSAlert.localized(alert: alert), badge: 1, sound: "default.wav", category: "MESSAGE_CATEGORY", acme1: ["bang", "whiz"])
        var options = NotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification, path: pushCertPath, password: pushPassword)
    }
    
    func testBackgroundPushExample() {
        let payload = CustomPayload1(acme1: "bar", acme2: 42)
        var options = NotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification, path: pushCertPath, password: pushPassword)
    }
    
    func testModifyingContentPushExample() {
        var alert = APSLocalizedAlert()
        alert.body = "Test mutable conten payload notification."
        let payload = CustomPayload3(alert: APSAlert.localized(alert: alert), badge: 1, sound: "default.wav", category: "MESSAGE_CATEGORY", encrypted: "Ω^¬%gq∞NÿÒQùw")
        var options = NotificationOptions.default
        options.type = .alert
        options.topic = topic
        let notification = APNSNotification.init(payload: payload, token: token, options: options)
        sendPushNotification(notification, path: pushCertPath, password: pushPassword)
    }
    
    private func sendPushNotification(_ notification: APNSNotification, path: String, password: String) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encoded = try! encoder.encode(notification.payload)
        print(String(data: encoded, encoding: .utf8)!)
        
        guard let identity: SecIdentity = identityFrom(path, password: password) else {
            XCTFail("Fail"); return
        }
        
        let expect = self.expectation(description: "APNSExpectation")
        let provider = APNSProvider.init(identity: identity)
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
    
    private func identityFrom(_ path: String, password: String) -> SecIdentity? {
        let url = URL(fileURLWithPath: path)
        let PKCS12Data = try? Data(contentsOf: url)
        let PKCS12options: NSDictionary = [kSecImportExportPassphrase as NSString: password]
        
        var items: CFArray?
        let status: OSStatus = SecPKCS12Import(PKCS12Data! as NSData, PKCS12options, &items)
        guard status == errSecSuccess else {
            XCTFail("Fail"); return nil
        }
        
        guard let theItemsCFArray = items else {
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
