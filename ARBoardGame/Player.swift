//
//  Player.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 23.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class Player: NSObject, NSCoding {
    let name: String

    var meeple: Meeple

    var foundEvidences: [Evidence]

    let peerID: MCPeerID

    enum CodingKeys: String, CodingKey {
        case name = "NameCodingKey"
        case meeple = "MeepleCodingKey"
        case foundEvidences = "FoundEvidencesCodingKey"
        case peerID = "PeerIDCodingKey"
    }

    init(_ name: String, _ meeple: Meeple, _ peerID: MCPeerID) {
        self.name = name
        self.meeple = meeple
        self.foundEvidences = []
        self.peerID = peerID
    }

    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as! String
        meeple = aDecoder.decodeObject(forKey: CodingKeys.meeple.rawValue) as! Meeple
        foundEvidences = aDecoder.decodeObject(forKey: CodingKeys.foundEvidences.rawValue) as! [Evidence]
        peerID = aDecoder.decodeObject(forKey: CodingKeys.peerID.rawValue) as! MCPeerID
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(meeple, forKey: CodingKeys.meeple.rawValue)
        aCoder.encode(foundEvidences, forKey: CodingKeys.foundEvidences.rawValue)
        aCoder.encode(peerID, forKey: CodingKeys.peerID.rawValue)
    }
}
