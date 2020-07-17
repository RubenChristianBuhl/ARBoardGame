//
//  GameFieldPattern.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 10.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class GameFieldPattern: NSObject, NSCoding {
    let corners: [CGPoint]

    var neighbors: [GameFieldPattern]

    var isStartField: Bool

    enum CodingKeys: String, CodingKey {
        case corners = "CornersCodingKey"
        case neighbors = "NeighborsCodingKey"
        case isStartField = "IsStartFieldCodingKey"
    }

    init(_ corners: [CGPoint], _ neighbors: [GameFieldPattern] = [], _ isStartField: Bool = false) {
        self.corners = corners
        self.neighbors = neighbors
        self.isStartField = isStartField
    }

    required init?(coder aDecoder: NSCoder) {
        self.corners = aDecoder.decodeObject(forKey: CodingKeys.corners.rawValue) as! [CGPoint]
        self.neighbors = aDecoder.decodeObject(forKey: CodingKeys.neighbors.rawValue) as! [GameFieldPattern]
        self.isStartField = aDecoder.decodeBool(forKey: CodingKeys.isStartField.rawValue)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(corners, forKey: CodingKeys.corners.rawValue)
        aCoder.encode(neighbors, forKey: CodingKeys.neighbors.rawValue)
        aCoder.encode(isStartField, forKey: CodingKeys.isStartField.rawValue)
    }
}
