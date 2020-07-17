//
//  Evidence.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 08.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class Evidence: NSObject, GameFieldContent {
    let possibleTreasureHidingGameFields: [GameField]

    enum CodingKeys: String, CodingKey {
        case possibleTreasureHidingGameFields = "PossibleTreasureHidingGameFieldsCodingKey"
    }

    init(_ possibleTreasureHidingGameFields: [GameField]) {
        self.possibleTreasureHidingGameFields = possibleTreasureHidingGameFields
    }

    required init?(coder aDecoder: NSCoder) {
        possibleTreasureHidingGameFields = aDecoder.decodeObject(forKey: CodingKeys.possibleTreasureHidingGameFields.rawValue) as! [GameField]
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(possibleTreasureHidingGameFields, forKey: CodingKeys.possibleTreasureHidingGameFields.rawValue)
    }

    func explore(_ delegate: GameFieldExplorerDelegate) {
        delegate.found(evidence: self)
    }
}
