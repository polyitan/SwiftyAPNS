//
//  SwiftyAPNSTests+Private.swift
//  SwiftyAPNSTests
//

import XCTest
@testable import SwiftyAPNS

extension SwiftyAPNSTests {
    func sendPushNotification<P: Payloadable>(_ notification: APNSNotification<P>) async throws {
#if false
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encoded = try! encoder.encode(notification.payload)
        print("Payload:\n\(String(data: encoded, encoding: .utf8)!)")
#endif
        let responce = try await provider.push(notification)
        XCTAssertNil(responce.reason)
    }
    
    func visit(notification: Notification) async throws {
        switch notification {
        case .payload(let notificatiuon):
            try await sendPushNotification(notificatiuon)
        case .payload4(let notificatiuon):
            try await sendPushNotification(notificatiuon)
        }
    }
    
    func readPropertyList(_ name: String) -> [String: String] {
        var propertyListFormat = PropertyListSerialization.PropertyListFormat.xml
        let plistPath = Bundle.module.url(forResource: name, withExtension: "plist")!
        let plistXML = FileManager.default.contents(atPath: plistPath.path)!
        let plistData = try! PropertyListSerialization.propertyList(from: plistXML,
                                                                    options: .mutableContainersAndLeaves,
                                                                    format: &propertyListFormat) as! [String: String]
        return plistData
    }
}
