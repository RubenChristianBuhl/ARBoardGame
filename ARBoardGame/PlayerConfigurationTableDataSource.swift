//
//  PlayerConfigurationTableDataSource.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 16.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class PlayerConfigurationTableDataSource: NSObject, UITableViewDataSource {
    @IBOutlet weak var playerConfigurationTableView: UITableView!

    let playerConfigurationCellIdentifier = "Player Configuration Cell"

    var playerConfigurations = [PlayerConfiguration]() {
        didSet {
            DispatchQueue.main.async {
                self.playerConfigurationTableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerConfigurations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playerConfigurationCell = tableView.dequeueReusableCell(withIdentifier: playerConfigurationCellIdentifier, for: indexPath)

        if let playerConfigurationCell = playerConfigurationCell as? PlayerConfigurationTableCell {
            playerConfigurationCell.meepleImageView.image = UIImage(fromImagesDirectory: playerConfigurations[indexPath.row].meeplePattern.previewImageFileName)

            playerConfigurationCell.nameLabel.text = playerConfigurations[indexPath.row].name
        }

        return playerConfigurationCell
    }
}
