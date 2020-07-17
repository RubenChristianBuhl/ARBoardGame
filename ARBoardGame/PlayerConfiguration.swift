//
//  PlayerConfiguration.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 16.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PlayerConfiguration: NSObject, NSCoding {
    let name: String

    var meeplePattern: MeeplePattern

    var peerID: MCPeerID

    enum CodingKeys: String, CodingKey {
        case name = "NameCodingKey"
        case meeplePattern = "MeeplePatternCodingKey"
        case peerID = "PeerIDCodingKey"
    }

    init(_ name: String, _ meeplePattern: MeeplePattern, _ peerID: MCPeerID) {
        self.name = name
        self.meeplePattern = meeplePattern
        self.peerID = peerID
    }

    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as! String
        self.meeplePattern = aDecoder.decodeObject(forKey: CodingKeys.meeplePattern.rawValue) as! MeeplePattern
        self.peerID = aDecoder.decodeObject(forKey: CodingKeys.peerID.rawValue) as! MCPeerID
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(meeplePattern, forKey: CodingKeys.meeplePattern.rawValue)
        aCoder.encode(peerID, forKey: CodingKeys.peerID.rawValue)
    }
}
