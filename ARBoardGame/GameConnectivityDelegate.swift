//
//  GameConnectivityDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 16.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import MultipeerConnectivity

protocol GameConnectivityDelegate {
    func receive(match: Match)
    func receive(player: Player)

    func playerConnected(_ playerName: String, peerID: MCPeerID)
    func playerLost(_ playerName: String, peerID: MCPeerID)
}
