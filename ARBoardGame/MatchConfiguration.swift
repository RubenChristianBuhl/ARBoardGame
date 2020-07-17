//
//  MatchConfiguration.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 16.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class MatchConfiguration: NSObject, NSCoding {
    var gameBoardPattern: GameBoardPattern

    var playerConfigurations: [PlayerConfiguration]

    let creator: PlayerConfiguration

    var playerNames: [String] {
        return playerConfigurations.map({ playerConfiguration in
            return playerConfiguration.name
        })
    }

    var meeplePatterns: [MeeplePattern] {
        return playerConfigurations.map({ playerConfiguration in
            return playerConfiguration.meeplePattern
        })
    }

    enum CodingKeys: String, CodingKey {
        case gameBoardPattern = "GameBoardPatternCodingKey"
        case playerConfigurations = "PlayerConfigurationsCodingKey"
        case creator = "CreatorCodingKey"
    }

    init(_ gameBoardPattern: GameBoardPattern, _ playerConfigurations: [PlayerConfiguration], _ creator: PlayerConfiguration) {
        self.gameBoardPattern = gameBoardPattern
        self.playerConfigurations = playerConfigurations
        self.creator = creator
    }

    required init?(coder aDecoder: NSCoder) {
        self.gameBoardPattern = aDecoder.decodeObject(forKey: CodingKeys.gameBoardPattern.rawValue) as! GameBoardPattern
        self.playerConfigurations = aDecoder.decodeObject(forKey: CodingKeys.playerConfigurations.rawValue) as! [PlayerConfiguration]
        self.creator = aDecoder.decodeObject(forKey: CodingKeys.creator.rawValue) as! PlayerConfiguration
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(gameBoardPattern, forKey: CodingKeys.gameBoardPattern.rawValue)
        aCoder.encode(playerConfigurations, forKey: CodingKeys.playerConfigurations.rawValue)
        aCoder.encode(creator, forKey: CodingKeys.creator.rawValue)
    }

    func getConfigurationOf(player playerName: String) -> PlayerConfiguration? {
        return playerConfigurations.first(where: { playerConfiguration in
            return playerConfiguration.name == playerName
        })
    }

    func removeConfigurationOf(player playerName: String) {
        playerConfigurations = playerConfigurations.filter({ playerConfiguration in
            return playerConfiguration.name != playerName
        })
    }
}
