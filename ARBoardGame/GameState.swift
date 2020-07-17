//
//  GameState.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 07.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit
import GameplayKit
import MultipeerConnectivity

class GameState: GKState, GameConnectivityDelegate {
    let scene: GameScene

    let connectivity: GameConnectivity

    let guide: GameGuide

    init(scene: GameScene, connectivity: GameConnectivity, guide: GameGuide) {
        self.scene = scene
        self.connectivity = connectivity
        self.guide = guide
    }

    override func didEnter(from previousState: GKState?) {
        connectivity.delegate = self
    }

    func receive(match: Match) {
    }

    func receive(player: Player) {
    }

    func playerConnected(_ playerName: String, peerID: MCPeerID) {
    }

    func playerLost(_ playerName: String, peerID: MCPeerID) {
    }

    func send(match: Match) {
        do {
            try connectivity.send(match: match)
        } catch {
            // send match failed
        }
    }

    func send(player: Player) {
        do {
            try connectivity.send(player: player)
        } catch {
            // send player failed
        }
    }
}
