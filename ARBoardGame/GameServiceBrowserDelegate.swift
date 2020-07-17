//
//  GameServiceBrowserDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 16.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import MultipeerConnectivity

class GameServiceBrowserDelegate: NSObject, MCNearbyServiceBrowserDelegate {
    private let timeoutSeconds = 600.0

    private let session: MCSession

    private var matchConfiguration: MatchConfiguration

    init(_ session: MCSession, _ matchConfiguration: MatchConfiguration) {
        self.session = session
        self.matchConfiguration = matchConfiguration
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let matchConfigurationData = NSKeyedArchiver.archivedData(withRootObject: matchConfiguration)

        browser.invitePeer(peerID, to: session, withContext: matchConfigurationData, timeout: timeoutSeconds)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }
}
