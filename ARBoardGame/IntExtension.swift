//
//  IntExtension.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 08.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import Foundation

extension Int {
    static func random(_ upperBound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperBound)))
    }
}
