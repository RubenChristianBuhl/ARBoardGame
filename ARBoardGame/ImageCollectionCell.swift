//
//  ImageCollectionCell.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 15.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var previewImageView: UIImageView!

    @IBOutlet weak var overlayView: UIView!

    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderColor = tintColor.cgColor
                layer.borderWidth = 4
            } else {
                layer.borderWidth = 0
            }

            overlayView.isHidden = isUserInteractionEnabled || isSelected
        }
    }

    override var isUserInteractionEnabled: Bool {
        didSet {
            overlayView.isHidden = isUserInteractionEnabled || isSelected
        }
    }
}
