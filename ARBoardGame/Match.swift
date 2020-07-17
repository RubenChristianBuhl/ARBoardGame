//
//  Match.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 23.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class Match: NSObject, NSCoding {
    let gameBoard: GameBoard

    var players: [Player]

    var currentPlayer: Player

    var winner: Player?

    var areAllMeeplesDeployed: Bool {
        var areAllMeeplesDeployed = true

        for player in players {
            areAllMeeplesDeployed = areAllMeeplesDeployed && player.meeple.isDeployed
        }

        return areAllMeeplesDeployed
    }

    enum CodingKeys: String, CodingKey {
        case gameBoard = "GameBoardCodingKey"
        case players = "PlayersCodingKey"
        case currentPlayer = "CurrentPlayerCodingKey"
        case winner = "WinnerCodingKey"
    }

    init(_ matchConfiguration: MatchConfiguration) {
        gameBoard = GameBoard(matchConfiguration.gameBoardPattern.gameFields, matchConfiguration.gameBoardPattern.arucoBoard)

        players = Match.createPlayers(from: matchConfiguration.playerConfigurations, and: gameBoard.startFields)

        currentPlayer = players.last!
    }

    required init?(coder aDecoder: NSCoder) {
        gameBoard = aDecoder.decodeObject(forKey: CodingKeys.gameBoard.rawValue) as! GameBoard
        players = aDecoder.decodeObject(forKey: CodingKeys.players.rawValue) as! [Player]
        currentPlayer = aDecoder.decodeObject(forKey: CodingKeys.currentPlayer.rawValue) as! Player
        winner = aDecoder.decodeObject(forKey: CodingKeys.winner.rawValue) as? Player
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(gameBoard, forKey: CodingKeys.gameBoard.rawValue)
        aCoder.encode(players, forKey: CodingKeys.players.rawValue)
        aCoder.encode(currentPlayer, forKey: CodingKeys.currentPlayer.rawValue)
        aCoder.encode(winner, forKey: CodingKeys.winner.rawValue)
    }

    func setNextCurrentPlayer() {
        if let currentPlayerIndex = players.index(of: currentPlayer) {
            let nextCurrentPlayerIndex = (currentPlayerIndex + 1) % players.count

            currentPlayer = players[nextCurrentPlayerIndex]
        }
    }

    func set(player: Player) {
        if let oldPlayer = getPlayer(with: player.name), let playerIndex = players.index(of: oldPlayer) {
            players[playerIndex] = player
        }
    }

    func getPlayer(with name: String) -> Player? {
        return players.filter({ player in
            return player.name == name
        }).first
    }

    class func createPlayers(from playerConfigurations: [PlayerConfiguration], and startFields: [GameField]) -> [Player] {
        var players = [Player]()

        for i in 0 ..< playerConfigurations.count {
            let meeplePattern = playerConfigurations[i].meeplePattern

            let meeple = Meeple(meeplePattern.visionLibModelFileName, meeplePattern.sceneModelFileName, startFields[i])

            let player = Player(playerConfigurations[i].name, meeple, playerConfigurations[i].peerID)

            players.append(player)
        }

        return players
    }
}
