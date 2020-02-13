import XCTest
@testable import SwiftyAPNS

final class SwiftyAPNSTests: XCTestCase {
    func testExample() {
        
        let alert    = APSAlert.plain(plain: "Test!!!")
        let payload  = Payload(alert: alert)
        let token    = "token"
        let notification = APNSNotification.init(payload: payload, token: token)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encoded = try! encoder.encode(payload)
        print(String(data: encoded, encoding: .utf8)!)
        
        let path = "/Users/setk/Desktop/dev_push_cert.p12"
        let url = URL(fileURLWithPath: path)
        
        let PKCS12Data = try? Data(contentsOf: url)
        let options: NSDictionary = [kSecImportExportPassphrase as NSString: "password"]
        
        var items: CFArray?
        let status: OSStatus = SecPKCS12Import(PKCS12Data! as NSData, options, &items)
        
        guard status == errSecSuccess else {
            XCTFail("Fail"); return
        }
        
        guard let theItemsCFArray = items else {
            XCTFail("Fail"); return
        }
        
        guard let dictArray = items as? [[String: AnyObject]] else {
            XCTFail("Fail"); return
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
            XCTFail("Fail"); return
        }
        
        let expect = self.expectation(description: "myExpectation")
        
        let provider = Provider.init(identity: identity)
        provider.push(notification) { (response, error) in
            XCTAssertTrue(error == nil, "No error")
            expect.fulfill()
        }
        
        self.waitForExpectations(timeout: 25.0) { (error) in
            if let error = error {
                print("Error \(error)")
            }
        }
        print("YEP!!!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
