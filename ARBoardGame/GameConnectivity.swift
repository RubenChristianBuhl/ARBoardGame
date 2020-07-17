//
//  GameConnectivity.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 16.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import MultipeerConnectivity

class GameConnectivity: NSObject {
    private let serviceType = "ar-board-game"

    private let session: MCSession

    private let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser

    private let nearbyServiceBrowser: MCNearbyServiceBrowser

    private var sessionDelegate: GameSessionDelegate?

    private var advertiserDelegate: GameServiceAdvertiserDelegate?

    private var browserDelegate: GameServiceBrowserDelegate?

    let peerID: MCPeerID

    var delegate: GameConnectivityDelegate?

    var matchCreationDelegate: MatchCreationConnectivityDelegate? {
        return delegate as? MatchCreationConnectivityDelegate
    }

    init(playerName: String) {
        peerID = MCPeerID(displayName: playerName)

        session = MCSession(peer: peerID)

        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)

        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)

        super.init()

        sessionDelegate = GameSessionDelegate(self)

        session.delegate = sessionDelegate
    }

    func send(match: Match) throws {
        let matchData = NSKeyedArchiver.archivedData(withRootObject: match)

        try session.send(matchData, toPeers: session.connectedPeers, with: .reliable)
    }

    func send(player: Player) throws {
        let playerData = NSKeyedArchiver.archivedData(withRootObject: player)

        try session.send(playerData, toPeers: session.connectedPeers, with: .reliable)
    }

    func send(matchConfiguration: MatchConfiguration) throws {
        let matchConfigurationData = NSKeyedArchiver.archivedData(withRootObject: matchConfiguration)

        try session.send(matchConfigurationData, toPeers: session.connectedPeers, with: .reliable)
    }

    func send(playerConfiguration: PlayerConfiguration) throws {
        let playerConfigurationData = NSKeyedArchiver.archivedData(withRootObject: playerConfiguration)

        try session.send(playerConfigurationData, toPeers: session.connectedPeers, with: .reliable)
    }

    func send(playerRejection: PlayerRejection, toPeer peerID: MCPeerID) throws {
        let playerRejectionData = NSKeyedArchiver.archivedData(withRootObject: playerRejection)

        try session.send(playerRejectionData, toPeers: [peerID], with: .reliable)
    }

    func disconnect() {
        session.disconnect()
    }

    func startAdvertisingPlayer(delegate: PlayerAdvertiserDelegate) {
        advertiserDelegate = GameServiceAdvertiserDelegate(delegate, session)

        nearbyServiceAdvertiser.delegate = advertiserDelegate

        nearbyServiceAdvertiser.startAdvertisingPeer()
    }

    func startBrowsingForPlayers(matchConfiguration: MatchConfiguration) {
        browserDelegate = GameServiceBrowserDelegate(session, matchConfiguration)

        nearbyServiceBrowser.delegate = browserDelegate

        nearbyServiceBrowser.startBrowsingForPeers()
    }

    func stopAdvertisingPlayer() {
        nearbyServiceAdvertiser.stopAdvertisingPeer()
    }

    func stopBrowsingForPlayers() {
        nearbyServiceBrowser.stopBrowsingForPeers()
    }
}
