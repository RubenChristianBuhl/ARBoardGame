//
//  MeepleCollectionDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 15.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class MeepleCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var meepleCollectionView: UICollectionView!

    let meepleCellIdentifier = "Meeple Cell"
    let meepleFileExtension = "meeple"
    let meepleDirectory = "Meeples"

    let defaultMeepleIndex = 0

    let meeplePatterns: [MeeplePattern]

    var delegate: MeepleSelectionDelegate!

    override init() {
        var meeplePatterns = [MeeplePattern]()

        if let meepleURLs = Bundle.main.urls(forResourcesWithExtension: meepleFileExtension, subdirectory: meepleDirectory) {
            for meepleURL in meepleURLs {
                if let meeplePattern = NSKeyedUnarchiver.unarchiveObject(withFile: meepleURL.path) as? MeeplePattern {
                    meeplePatterns.append(meeplePattern)
                }
            }
        }

        self.meeplePatterns = meeplePatterns
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meeplePatterns.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meepleCell = collectionView.dequeueReusableCell(withReuseIdentifier: meepleCellIdentifier, for: indexPath)

        if let imageCollectionCell = meepleCell as? ImageCollectionCell {
            imageCollectionCell.previewImageView.image = UIImage(fromImagesDirectory: meeplePatterns[indexPath.item].previewImageFileName)

            imageCollectionCell.isUserInteractionEnabled = !delegate.getSelectedMeeples().contains(meeplePatterns[indexPath.item])
        }

        return meepleCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.didSelect(meeple: meeplePatterns[indexPath.item])
    }

    func select(meeple: MeeplePattern) {
        if let meepleIndex = meeplePatterns.index(of: meeple) {
            let meepleIndexPath = IndexPath(item: meepleIndex, section: 0)

            DispatchQueue.main.async {
                self.meepleCollectionView.selectItem(at: meepleIndexPath, animated: false, scrollPosition: .centeredHorizontally)

                self.setCellsUserInteractionEnabled()
            }
        }
    }

    func setCellsUserInteractionEnabled() {
        for indexPath in meepleCollectionView.indexPathsForVisibleItems {
            meepleCollectionView.cellForItem(at: indexPath)?.isUserInteractionEnabled = !delegate.getSelectedMeeples().contains(meeplePatterns[indexPath.item])
        }
    }

    func getDefaultMeeple() -> MeeplePattern {
        return meeplePatterns[defaultMeepleIndex]
    }
}
