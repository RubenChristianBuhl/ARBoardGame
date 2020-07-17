//
//  MatchInvitationTableCell.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 18.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class MatchInvitationTableCell: UITableViewCell {
    @IBOutlet weak var gameBoardImageView: UIImageView!

    @IBOutlet weak var creatorNameLabel: UILabel!

    var reply: ((Bool) -> Void)?

    @IBAction func join(_ sender: UIButton) {
        reply?(true)
    }
}
