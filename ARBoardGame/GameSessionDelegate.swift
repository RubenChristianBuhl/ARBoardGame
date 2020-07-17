//
//  GameSessionDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 16.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import MultipeerConnectivity

class GameSessionDelegate: NSObject, MCSessionDelegate {
    private let gameConnectivity: GameConnectivity

    init(_ gameConnectivity: GameConnectivity) {
        self.gameConnectivity = gameConnectivity
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let playerName = peerID.displayName

        if state == .connected {
            gameConnectivity.delegate?.playerConnected(playerName, peerID: peerID)
        } else if state == .notConnected {
            gameConnectivity.delegate?.playerLost(playerName, peerID: peerID)
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let object = NSKeyedUnarchiver.unarchiveObject(with: data)

        if let match = object as? Match {
            gameConnectivity.delegate?.receive(match: match)
        } else if let player = object as? Player {
            gameConnectivity.delegate?.receive(player: player)
        } else if let matchConfiguration = object as? MatchConfiguration {
            gameConnectivity.matchCreationDelegate?.receive(matchConfiguration: matchConfiguration)
        } else if let playerConfiguration = object as? PlayerConfiguration {
            gameConnectivity.matchCreationDelegate?.receive(playerConfiguration: playerConfiguration)
        } else if let playerRejection = object as? PlayerRejection {
            gameConnectivity.matchCreationDelegate?.receive(playerRejection: playerRejection)
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}
