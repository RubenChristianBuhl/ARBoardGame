//
//  SCNBoxExtension.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 04.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import Foundation

extension SCNBox {
    convenience init(min: SCNVector3, max: SCNVector3) {
        self.init(vector: max - min)
    }

    convenience init(vector: SCNVector3) {
        self.init(width: CGFloat(vector.x), height: CGFloat(vector.y), length: CGFloat(vector.z), chamferRadius: 0)
    }
}
