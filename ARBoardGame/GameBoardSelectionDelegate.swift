//
//  GameBoardSelectionDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 15.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import Foundation

protocol GameBoardSelectionDelegate {
    var isCreator: Bool {
        get
    }

    var playerCount: Int {
        get
    }

    func didSelect(gameBoard: GameBoardPattern)
}
