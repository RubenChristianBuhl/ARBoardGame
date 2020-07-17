//
//  GameBoard.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 23.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class GameBoard: NSObject, NSCoding {
    let evidenceGameFieldsCountDivisor = 4

    let gameFields: [GameField]
    let startFields: [GameField]

    let arucoBoard: ArucoBoard

    private var gameFieldsWhichAreNoStartField: [GameField] {
        return gameFields.filter({ gameField in
            return !startFields.contains(gameField)
        })
    }

    enum CodingKeys: String, CodingKey {
        case gameFields = "GameFieldsCodingKey"
        case startFields = "StartFieldsCodingKey"
        case arucoBoard = "ArucoBoardCodingKey"
    }

    init(_ gameFieldPatterns: [GameFieldPattern], _ arucoBoard: ArucoBoard) {
        (gameFields, startFields) = GameBoard.createGameFields(from: gameFieldPatterns)

        self.arucoBoard = arucoBoard

        super.init()

        generateContentsForGameFields()
    }

    required init?(coder aDecoder: NSCoder) {
        gameFields = aDecoder.decodeObject(forKey: CodingKeys.gameFields.rawValue) as! [GameField]
        startFields = aDecoder.decodeObject(forKey: CodingKeys.startFields.rawValue) as! [GameField]
        arucoBoard = aDecoder.decodeObject(forKey: CodingKeys.arucoBoard.rawValue) as! ArucoBoard
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(gameFields, forKey: CodingKeys.gameFields.rawValue)
        aCoder.encode(startFields, forKey: CodingKeys.startFields.rawValue)
        aCoder.encode(arucoBoard, forKey: CodingKeys.arucoBoard.rawValue)
    }

    private func generateContentsForGameFields() {
        var evidenceGameFields = gameFieldsWhichAreNoStartField

        let treasureGameFieldIndex = Int.random(evidenceGameFields.count)

        let treasureGameField = evidenceGameFields.remove(at: treasureGameFieldIndex)

        treasureGameField.content = Treasure()

        for evidenceGameField in evidenceGameFields {
            evidenceGameField.content = createEvidence(forGameField: evidenceGameField, fromGameFields: evidenceGameFields, withTreasureHidingGameField: treasureGameField)
        }
    }

    private func createEvidence(forGameField gameField: GameField, fromGameFields gameFields: [GameField], withTreasureHidingGameField treasureHidingGameField: GameField) -> Evidence {
        var possibleTreasureHidingGameFields = [treasureHidingGameField]

        let maxPossibleTreasureHidingGameFieldsCount = gameFields.count / evidenceGameFieldsCountDivisor

        while possibleTreasureHidingGameFields.count < maxPossibleTreasureHidingGameFieldsCount {
            let possibleTreasureHidingGameFieldIndex = Int.random(gameFields.count)

            let possibleTreasureHidingGameField = gameFields[possibleTreasureHidingGameFieldIndex]

            if !possibleTreasureHidingGameFields.contains(possibleTreasureHidingGameField) && gameField != possibleTreasureHidingGameField {
                possibleTreasureHidingGameFields.append(possibleTreasureHidingGameField)
            }
        }

        return Evidence(possibleTreasureHidingGameFields)
    }

    class func createGameFields(from gameFieldPatterns: [GameFieldPattern]) -> (gameFields: [GameField], startFields: [GameField]) {
        var gameFields = [GameFieldPattern : GameField]()

        for gameFieldPattern in gameFieldPatterns {
            gameFields[gameFieldPattern] = GameField(gameFieldPattern.corners)
        }

        for gameField in gameFields {
            let neighbors = gameFields.filter({ neighborGameField in
                return gameField.key.neighbors.contains(neighborGameField.key)
            })

            gameField.value.addConnections(to: Array(neighbors.values), bidirectional: false)
        }

        let startFields = gameFields.filter({ gameField in
            return gameField.key.isStartField
        })

        return (Array(gameFields.values), Array(startFields.values))
    }
}
