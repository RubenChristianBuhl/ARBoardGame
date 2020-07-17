//
//  ArucoBoard.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 09.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class ArucoBoard: NSObject, NSCoding {
    @objc
    let dictionaryID: Int

    @objc
    let markers: [ArucoMarker]

    enum CodingKeys: String, CodingKey {
        case dictionaryID = "DictionaryIDCodingKey"
        case markers = "MarkersCodingKey"
    }

    init(_ dictionaryID: Int, _ markers: [ArucoMarker]) {
        self.dictionaryID = dictionaryID
        self.markers = markers
    }

    required init?(coder aDecoder: NSCoder) {
        dictionaryID = aDecoder.decodeInteger(forKey: CodingKeys.dictionaryID.rawValue)
        markers = aDecoder.decodeObject(forKey: CodingKeys.markers.rawValue) as! [ArucoMarker]
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(dictionaryID, forKey: CodingKeys.dictionaryID.rawValue)
        aCoder.encode(markers, forKey: CodingKeys.markers.rawValue)
    }
}
