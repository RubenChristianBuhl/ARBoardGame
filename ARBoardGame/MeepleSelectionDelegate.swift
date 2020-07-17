//
//  MeepleSelectionDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 15.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import Foundation

protocol MeepleSelectionDelegate {
    func didSelect(meeple: MeeplePattern)

    func getSelectedMeeples() -> [MeeplePattern]
}
