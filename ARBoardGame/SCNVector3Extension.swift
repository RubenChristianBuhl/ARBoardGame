//
//  SCNVector3Extension.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 04.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import Foundation

extension SCNVector3 {
    static func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
    }
}
