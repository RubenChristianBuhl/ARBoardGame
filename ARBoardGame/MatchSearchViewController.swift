//
//  MatchSearchViewController.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 29.01.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class MatchSearchViewController: UIViewController, PlayerAdvertiserDelegate {
    @IBOutlet var matchInvitationTableDataSource: MatchInvitationTableDataSource!

    var playerName: String!

    var connectivity: GameConnectivity!

    var matchConfiguration: MatchConfiguration?

    override func viewDidLoad() {
        super.viewDidLoad()

        connectivity = GameConnectivity(playerName: playerName)

        connectivity.startAdvertisingPlayer(delegate: self)
    }

    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)

        connectivity.stopAdvertisingPlayer()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let matchCreationViewController = segue.destination as? MatchCreationViewController {
            connectivity.stopAdvertisingPlayer()

            matchCreationViewController.playerName = playerName
            matchCreationViewController.matchConfiguration = matchConfiguration
            matchCreationViewController.connectivity = connectivity
        }
    }

    func receiveInvitation(matchConfiguration: MatchConfiguration, replyInvitation: @escaping (Bool) -> Void) {
        matchInvitationTableDataSource.matchInvitations.append((matchConfiguration, { reply in
            self.matchConfiguration = matchConfiguration

            replyInvitation(reply)
        }))
    }
}
