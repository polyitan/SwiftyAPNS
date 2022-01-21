//
//  SoundInfo.swift
//  SwiftyAPNS
//
//  Created by Sergii Tkachenko on 21.01.2022.
//  Copyright © 2022 Sergii Tkachenko. All rights reserved.
//

/// Child properties of the sound property.
public struct APSSoundInfo: Encodable {
    /// The flag that enables the critical alert.
    public var critical: Bool?
    
    /// The name of a sound file in the app bundle or in the Library/Sounds folder of
    /// the app’s data container.
    public var name: String?
    
    /// The volume for the critical alert’s sound.
    /// Set this to a value between 0 (silent) and 1 (full volume).
    public var volume: Double?
}
