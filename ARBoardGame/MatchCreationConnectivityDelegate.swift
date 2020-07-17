//
//  MatchCreationConnectivityDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 23.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

protocol MatchCreationConnectivityDelegate: GameConnectivityDelegate {
    func receive(matchConfiguration: MatchConfiguration)
    func receive(playerConfiguration: PlayerConfiguration)
    func receive(playerRejection: PlayerRejection)
}
