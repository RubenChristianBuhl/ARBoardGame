//
//  MatchCreationViewController.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 29.01.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MatchCreationViewController: UIViewController, GameBoardSelectionDelegate, MeepleSelectionDelegate, MatchCreationConnectivityDelegate {
    @IBOutlet weak var startMatchButton: UIButton!

    @IBOutlet var gameBoardCollectionDelegate: GameBoardCollectionDelegate!
    @IBOutlet var meepleCollectionDelegate: MeepleCollectionDelegate!

    @IBOutlet var playerConfigurationTableDataSource: PlayerConfigurationTableDataSource!

    let startMatchSegueIdentifier = "Start Match Segue"

    var isCreator: Bool = false
    var isCanceled: Bool = false

    var playerName: String!

    var matchConfiguration: MatchConfiguration!

    var connectivity: GameConnectivity!

    var match: Match?

    var rejectedPlayerPeers = [MCPeerID]()

    var playerCount: Int {
        return matchConfiguration.playerConfigurations.count
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if matchConfiguration == nil {
            isCreator = true
        }

        startMatchButton.isEnabled = isCreator

        if isCreator {
            connectivity = GameConnectivity(playerName: playerName)

            matchConfiguration = createDefaultMatchConfiguration()

            connectivity.startBrowsingForPlayers(matchConfiguration: matchConfiguration)
        }

        gameBoardCollectionDelegate.delegate = self
        meepleCollectionDelegate.delegate = self
        connectivity.delegate = self

        select(matchConfiguration: matchConfiguration)

        setTableDataSourcePlayerConfigurations()
    }

    @IBAction func startMatch(_ sender: UIButton) {
        let match = Match(matchConfiguration)

        connectivity.stopBrowsingForPlayers()

        send(match: match)

        receive(match: match)
    }

    @IBAction func cancel(_ sender: UIButton) {
        cancel()
    }

    func cancel(reason: String)  {
        let alertController = UIAlertController(title: "Disconnection", message: reason, preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        alertController.addAction(alertAction)

        present(alertController, animated: false, completion: {
            self.cancel()
        })
    }

    func cancel() {
        isCanceled = true

        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: false)
        }

        if isCreator {
            connectivity.stopBrowsingForPlayers()
        }

        connectivity.disconnect()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameViewController = segue.destination as? GameViewController {
            gameViewController.match = match
            gameViewController.connectivity = connectivity

            gameViewController.player = match?.getPlayer(with: playerName)
        }
    }

    func didSelect(gameBoard: GameBoardPattern) {
        if isCreator {
            matchConfiguration.gameBoardPattern = gameBoard

            send(matchConfiguration: matchConfiguration)
        }
    }

    func didSelect(meeple: MeeplePattern) {
        let playerConfiguration = PlayerConfiguration(playerName, meeple, connectivity.peerID)

        if isCreator {
            receive(playerConfiguration: playerConfiguration)
        } else {
            send(playerConfiguration: playerConfiguration)
        }
    }

    func getSelectedMeeples() -> [MeeplePattern] {
        return matchConfiguration.meeplePatterns
    }

    func receive(match: Match) {
        self.match = match

        DispatchQueue.main.async {
            self.performSegue(withIdentifier: self.startMatchSegueIdentifier, sender: self)
        }
    }

    func receive(player: Player) {
    }

    func receive(matchConfiguration: MatchConfiguration) {
        self.matchConfiguration = matchConfiguration

        select(matchConfiguration: matchConfiguration)

        setTableDataSourcePlayerConfigurations()
    }

    func receive(playerConfiguration: PlayerConfiguration) {
        if isCreator {
            if !matchConfiguration.meeplePatterns.contains(playerConfiguration.meeplePattern) {
                matchConfiguration.getConfigurationOf(player: playerConfiguration.name)?.meeplePattern = playerConfiguration.meeplePattern

                send(matchConfiguration: matchConfiguration)

                select(matchConfiguration: matchConfiguration)

                setTableDataSourcePlayerConfigurations()
            }
        }
    }

    func receive(playerRejection: PlayerRejection) {
        cancel(reason: playerRejection.reason)
    }

    func playerConnected(_ playerName: String, peerID: MCPeerID) {
        if isCreator {
            if isAvailable(playerName: playerName) {
                if matchConfiguration.playerConfigurations.count < matchConfiguration.gameBoardPattern.getStartFieldCount() {
                    if let meeplePattern = getUnselectedMeeplePatterns(in: matchConfiguration).first {
                        let playerConfiguration = PlayerConfiguration(playerName, meeplePattern, peerID)

                        matchConfiguration.playerConfigurations.append(playerConfiguration)

                        select(matchConfiguration: matchConfiguration)

                        setTableDataSourcePlayerConfigurations()

                        send(matchConfiguration: matchConfiguration)
                    } else {
                        let playerRejection = PlayerRejection(playerName, "No more Meeples available.")

                        send(playerRejection: playerRejection, toPeer: peerID)
                    }
                } else {
                    let playerRejection = PlayerRejection(playerName, "Maximum player count for selected game board exceeded.")

                    send(playerRejection: playerRejection, toPeer: peerID)
                }
            } else {
                let playerRejection = PlayerRejection(playerName, "Player name already taken.")

                send(playerRejection: playerRejection, toPeer: peerID)
            }
        }
    }

    func playerLost(_ playerName: String, peerID: MCPeerID) {
        if !isCanceled {
            if isCreator {
                if let rejectedPlayerPeerIndex = rejectedPlayerPeers.index(of: peerID) {
                    rejectedPlayerPeers.remove(at: rejectedPlayerPeerIndex)
                } else {
                    matchConfiguration.removeConfigurationOf(player: playerName)

                    send(matchConfiguration: matchConfiguration)

                    select(matchConfiguration: matchConfiguration)

                    setTableDataSourcePlayerConfigurations()
                }
            } else if peerID == matchConfiguration.creator.peerID {
                cancel(reason: "Connection to match creator lost.")
            }
        }
    }

    func send(match: Match) {
        do {
            try connectivity.send(match: match)
        } catch {
            // send match failed
        }
    }

    func send(matchConfiguration: MatchConfiguration) {
        do {
            try connectivity.send(matchConfiguration: matchConfiguration)
        } catch {
            // send match configuration failed
        }
    }

    func send(playerConfiguration: PlayerConfiguration) {
        do {
            try connectivity.send(playerConfiguration: playerConfiguration)
        } catch {
            // send player configuration failed
        }
    }

    func send(playerRejection: PlayerRejection, toPeer peerID: MCPeerID) {
        rejectedPlayerPeers.append(peerID)

        do {
            try connectivity.send(playerRejection: playerRejection, toPeer: peerID)
        } catch {
            // send player playerRejection failed
        }
    }

    func isAvailable(playerName: String) -> Bool {
        return !matchConfiguration.playerNames.contains(playerName)
    }

    func setTableDataSourcePlayerConfigurations() {
        playerConfigurationTableDataSource.playerConfigurations = matchConfiguration.playerConfigurations
    }

    func createDefaultMatchConfiguration() -> MatchConfiguration {
        let defaultGameBoard = gameBoardCollectionDelegate.getDefaultGameBoard()
        let defaultMeeple = meepleCollectionDelegate.getDefaultMeeple()

        let playerConfiguration = PlayerConfiguration(playerName, defaultMeeple, connectivity.peerID)

        return MatchConfiguration(defaultGameBoard, [
            playerConfiguration
        ], playerConfiguration)
    }

    func select(matchConfiguration: MatchConfiguration) {
        gameBoardCollectionDelegate.select(gameBoard: matchConfiguration.gameBoardPattern)

        if let playerConfiguration = matchConfiguration.getConfigurationOf(player: playerName) {
            meepleCollectionDelegate.select(meeple: playerConfiguration.meeplePattern)
        }
    }

    func getUnselectedMeeplePatterns(in matchConfiguration: MatchConfiguration) -> [MeeplePattern] {
        let meeplePatterns = Set(meepleCollectionDelegate.meeplePatterns)

        let unselectedMeeplePatterns = meeplePatterns.subtracting(matchConfiguration.meeplePatterns)

        return Array(unselectedMeeplePatterns)
    }
}
