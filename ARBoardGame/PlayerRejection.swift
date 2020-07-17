//
//  PlayerRejection.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 22.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class PlayerRejection: NSObject, NSCoding {
    let playerName: String

    let reason: String

    enum CodingKeys: String, CodingKey {
        case playerName = "PlayerNameCodingKey"
        case reason = "ReasonCodingKey"
    }

    init(_ playerName: String, _ reason: String) {
        self.playerName = playerName
        self.reason = reason
    }

    required init?(coder aDecoder: NSCoder) {
        self.playerName = aDecoder.decodeObject(forKey: CodingKeys.playerName.rawValue) as! String
        self.reason = aDecoder.decodeObject(forKey: CodingKeys.reason.rawValue) as! String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(playerName, forKey: CodingKeys.playerName.rawValue)
        aCoder.encode(reason, forKey: CodingKeys.reason.rawValue)
    }
}
