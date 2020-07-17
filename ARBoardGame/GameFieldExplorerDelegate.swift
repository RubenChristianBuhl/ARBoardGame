//
//  GameFieldExplorerDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 08.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

protocol GameFieldExplorerDelegate {
    func win()

    func found(evidence: Evidence)
}
