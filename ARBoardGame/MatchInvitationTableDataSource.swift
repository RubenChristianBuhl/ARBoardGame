//
//  MatchInvitationTableDataSource.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 18.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class MatchInvitationTableDataSource: NSObject, UITableViewDataSource {
    @IBOutlet weak var matchInvitationTableView: UITableView!

    let matchInvitationCellIdentifier = "Match Invitation Cell"
    let searchIndicatorCellIdentifier = "Search Indicator Cell"

    var matchInvitations = [(matchConfiguration: MatchConfiguration, replyInvitation: (Bool) -> Void)]() {
        didSet {
            DispatchQueue.main.async {
                self.matchInvitationTableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchInvitations.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: matchInvitationCellIdentifier, for: indexPath)

        if indexPath.row == matchInvitations.count {
            cell = tableView.dequeueReusableCell(withIdentifier: searchIndicatorCellIdentifier, for: indexPath)
        }

        if let matchInvitationCell = cell as? MatchInvitationTableCell {
            matchInvitationCell.gameBoardImageView.image = UIImage(fromImagesDirectory: matchInvitations[indexPath.row].matchConfiguration.gameBoardPattern.previewImageFileName)

            matchInvitationCell.creatorNameLabel.text = matchInvitations[indexPath.row].matchConfiguration.creator.name

            matchInvitationCell.reply = matchInvitations[indexPath.row].replyInvitation
        } else if let searchIndicatorCell = cell as? SearchIndicatorTableCell {
            searchIndicatorCell.searchActivityIndicatorView.startAnimating()
        }

        return cell
    }
}
