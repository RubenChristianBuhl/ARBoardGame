//
//  GameFieldContent.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 08.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

protocol GameFieldContent: NSCoding {
    func explore(_ delegate: GameFieldExplorerDelegate)
}
