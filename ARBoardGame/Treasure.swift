//
//  Treasure.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 08.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class Treasure: NSObject, GameFieldContent {
    override init() {
    }

    required init?(coder aDecoder: NSCoder) {
    }

    func encode(with aCoder: NSCoder) {
    }

    func explore(_ delegate: GameFieldExplorerDelegate) {
        delegate.win()
    }
}
