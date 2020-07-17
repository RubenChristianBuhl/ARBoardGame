//
//  ArucoMarker.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 09.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class ArucoMarker: NSObject, NSCoding {
    @objc
    let id: Int

    @objc
    let rectangle: CGRect

    enum CodingKeys: String, CodingKey {
        case id = "IDCodingKey"
        case rectangle = "RectangleCodingKey"
    }

    init(_ id: Int, _ rectangle: CGRect) {
        self.id = id
        self.rectangle = rectangle
    }

    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: CodingKeys.id.rawValue)
        rectangle = aDecoder.decodeCGRect(forKey: CodingKeys.rectangle.rawValue)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: CodingKeys.id.rawValue)
        aCoder.encode(rectangle, forKey: CodingKeys.rectangle.rawValue)
    }
}
