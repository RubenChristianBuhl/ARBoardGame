//
//  GameBoardPattern.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 10.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class GameBoardPattern: NSObject, NSCoding {
    let gameFields: [GameFieldPattern]

    let arucoBoard: ArucoBoard

    let previewImageFileName: String

    enum CodingKeys: String, CodingKey {
        case gameFields = "GameFieldsCodingKey"
        case arucoBoard = "ArucoBoardCodingKey"
        case previewImageFileName = "PreviewImageFileNameCodingKey"
    }

    init(_ gameFields: [GameFieldPattern], _ arucoBoard: ArucoBoard, _ previewImageFileName: String) {
        self.gameFields = gameFields
        self.arucoBoard = arucoBoard
        self.previewImageFileName = previewImageFileName
    }

    required init?(coder aDecoder: NSCoder) {
        self.gameFields = aDecoder.decodeObject(forKey: CodingKeys.gameFields.rawValue) as! [GameFieldPattern]
        self.arucoBoard = aDecoder.decodeObject(forKey: CodingKeys.arucoBoard.rawValue) as! ArucoBoard
        self.previewImageFileName = aDecoder.decodeObject(forKey: CodingKeys.previewImageFileName.rawValue) as! String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(gameFields, forKey: CodingKeys.gameFields.rawValue)
        aCoder.encode(arucoBoard, forKey: CodingKeys.arucoBoard.rawValue)
        aCoder.encode(previewImageFileName, forKey: CodingKeys.previewImageFileName.rawValue)
    }

    func getStartFieldCount() -> Int {
        return gameFields.filter({ gameField in
            return gameField.isStartField
        }).count
    }

    override func isEqual(_ object: Any?) -> Bool {
        var isEqual = false

        if let gameBoardPattern = object as? GameBoardPattern {
            isEqual = previewImageFileName == gameBoardPattern.previewImageFileName
        }

        return isEqual
    }
}
