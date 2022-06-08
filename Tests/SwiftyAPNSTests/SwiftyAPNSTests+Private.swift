//
//  SwiftyAPNSTests+Private.swift
//  SwiftyAPNSTests
//

import XCTest
@testable import SwiftyAPNS

extension SwiftyAPNSTests {
    func sendPushNotification<P: Payloadable>(_ notification: APNSNotification<P>) {
#if false
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encoded = try! encoder.encode(notification.payload)
        print("Payload:\n\(String(data: encoded, encoding: .utf8)!)")
#endif
        let expect = self.expectation(description: "APNSExpectation")
        provider.push(notification) { (result) in
            switch(result) {
            case .success(let responce):
                if let error = responce.reason {
                    XCTFail(error.errorDescription ?? "Failure send push notification")
                } else {
                    print("ApnsId: \(responce.apnsId)")
                    expect.fulfill()
                }
            case .failure(let error):
                if let error = error as? LocalizedError {
                    XCTFail(error.localizedDescription)
                } else {
                    XCTFail("Failure send push notification")
                }
            }
        }
    }
    
    func waitForResponce() {
        self.waitForExpectations(timeout: 30.0) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func visit(notification: Notification) {
        switch notification {
        case .payload(let notificatiuon):
            sendPushNotification(notificatiuon)
        case .payload4(let notificatiuon):
            sendPushNotification(notificatiuon)
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
