//
//  GameServiceAdvertiserDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 16.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import MultipeerConnectivity

class GameServiceAdvertiserDelegate: NSObject, MCNearbyServiceAdvertiserDelegate {
    private let delegate: PlayerAdvertiserDelegate

    private let session: MCSession

    init(_ delegate: PlayerAdvertiserDelegate, _ session: MCSession) {
        self.delegate = delegate
        self.session = session
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        var contextObject: Any?

        if let contextData = context {
            contextObject = NSKeyedUnarchiver.unarchiveObject(with: contextData)
        }

        if let matchConfiguration = contextObject as? MatchConfiguration {
            delegate.receiveInvitation(matchConfiguration: matchConfiguration, replyInvitation: { reply in
                invitationHandler(reply, self.session)
            })
        }
    }
}
