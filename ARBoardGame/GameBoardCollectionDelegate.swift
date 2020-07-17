//
//  GameBoardsCollectionDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 15.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class GameBoardCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var gameBoardCollectionView: UICollectionView!

    let gameBoardCellIdentifier = "Game Board Cell"
    let gameBoardFileExtension = "gameboard"
    let gameBoardDirectory = "Game Boards"

    let defaultGameBoardIndex = 0

    let gameBoardPatterns: [GameBoardPattern]

    var delegate: GameBoardSelectionDelegate!

    override init() {
        var gameBoardPatterns = [GameBoardPattern]()

        if let gameBoardURLs = Bundle.main.urls(forResourcesWithExtension: gameBoardFileExtension, subdirectory: gameBoardDirectory) {
            for gameBoardURL in gameBoardURLs {
                if let gameBoardPattern = NSKeyedUnarchiver.unarchiveObject(withFile: gameBoardURL.path) as? GameBoardPattern {
                    gameBoardPatterns.append(gameBoardPattern)
                }
            }
        }

        self.gameBoardPatterns = gameBoardPatterns
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameBoardPatterns.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gameBoardCell = collectionView.dequeueReusableCell(withReuseIdentifier: gameBoardCellIdentifier, for: indexPath)

        if let imageCollectionCell = gameBoardCell as? ImageCollectionCell {
            imageCollectionCell.previewImageView.image = UIImage(fromImagesDirectory: gameBoardPatterns[indexPath.item].previewImageFileName)

            imageCollectionCell.isUserInteractionEnabled = delegate.isCreator && delegate.playerCount <= gameBoardPatterns[indexPath.item].getStartFieldCount()
        }

        return gameBoardCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.didSelect(gameBoard: gameBoardPatterns[indexPath.item])
    }

    func select(gameBoard: GameBoardPattern) {
        if let gameBoardIndex = gameBoardPatterns.index(of: gameBoard) {
            let gameBoardIndexPath = IndexPath(item: gameBoardIndex, section: 0)

            DispatchQueue.main.async {
                self.gameBoardCollectionView.selectItem(at: gameBoardIndexPath, animated: false, scrollPosition: .centeredHorizontally)

                self.setCellsUserInteractionEnabled()
            }
        }
    }

    func setCellsUserInteractionEnabled() {
        for indexPath in gameBoardCollectionView.indexPathsForVisibleItems {
            gameBoardCollectionView.cellForItem(at: indexPath)?.isUserInteractionEnabled = delegate.isCreator && delegate.playerCount <= gameBoardPatterns[indexPath.item].getStartFieldCount()
        }
    }

    func getDefaultGameBoard() -> GameBoardPattern {
        return gameBoardPatterns[defaultGameBoardIndex]
    }
}
