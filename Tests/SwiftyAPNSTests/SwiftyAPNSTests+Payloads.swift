//
//  SwiftyAPNSTests+Payloads.swift
//  SwiftyAPNSTests
//

@testable import SwiftyAPNS

extension SwiftyAPNSTests {
    static var plainAlert: APNSPayload {
        return APNSPayload(alert: .plain(plain: "Test Alert notification."))
    }
    
    static var localizedAlert: APNSPayload {
        var alert = APSLocalizedAlert()
        alert.title = "Test"
        alert.subtitle = "Alert notification"
        alert.body = "with subtitle."
        return APNSPayload(alert: .localized(alert: alert))
    }
    
    static var localizedCustomAlert1: CustomPayload1 {
        var alert = APSLocalizedAlert()
        alert.body = "Test Alert with custom payload notification."
        return CustomPayload1(alert: .localized(alert: alert),
                              badge: 1,
                              sound: .regular(sound: "default.wav"),
                              category: "MESSAGE_CATEGORY",
                              acme1: "bar",
                              acme2: 42)
    }
    
    static var localizedCustomAlert2: CustomPayload2 {
        var alert = APSLocalizedAlert()
        alert.body = "Test Alert with custom payload notification."
        return CustomPayload2(alert: .localized(alert: alert),
                              badge: 1,
                              sound: .regular(sound: "default.wav"),
                              category: "MESSAGE_CATEGORY",
                              acme1: ["bang", "whiz"])
    }
    
    static var localizedCustomAlert3: CustomPayload3 {
        var alert = APSLocalizedAlert()
        alert.body = "Test mutable conten payload notification."
        return CustomPayload3(alert: .localized(alert: alert),
                              badge: 1,
                              sound: .regular(sound: "default.wav"),
                              category: "MESSAGE_CATEGORY",
                              encrypted: "Ω^¬%gq∞NÿÒQùw")
    }
    
    static var localizedCustomAlert4: CustomPayload4 {
        return CustomPayload4(acme1: "bar", acme2: 42)
    }
    
    static var localizedAlert5: APNSPayload {
        var alert = APSLocalizedAlert()
        alert.locKey = "Frends: %@, %@"
        alert.locArgs = ["Jenna", "Frank"]
        return APNSPayload(alert: .localized(alert: alert))
    }
    
    static var localizedAlert6: APNSPayload {
        var alert = APSLocalizedAlert()
        alert.body = "Test Alert with custom action notification."
        return APNSPayload(alert: .localized(alert: alert),
                           badge: 1,
                           sound: .regular(sound: "default.wav"),
                           category: "MESSAGE_CATEGORY")
    }
}
