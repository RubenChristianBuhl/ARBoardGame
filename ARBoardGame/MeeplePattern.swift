//
//  MeeplePattern.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 05.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class MeeplePattern: NSObject, NSCoding {
    let previewImageFileName: String
    let visionLibModelFileName: String
    let sceneModelFileName: String

    enum CodingKeys: String, CodingKey {
        case previewImageFileName = "PreviewImageFileNameCodingKey"
        case visionLibModelFileName = "VisionLibModelFileNameCodingKey"
        case sceneModelFileName = "SceneModelFileNameCodingKey"
    }

    init(_ previewImageFileName: String, _ visionLibModelFileName: String, _ sceneModelFileName: String) {
        self.previewImageFileName = previewImageFileName
        self.visionLibModelFileName = visionLibModelFileName
        self.sceneModelFileName = sceneModelFileName
    }

    required init?(coder aDecoder: NSCoder) {
        previewImageFileName = aDecoder.decodeObject(forKey: CodingKeys.previewImageFileName.rawValue) as! String
        visionLibModelFileName = aDecoder.decodeObject(forKey: CodingKeys.visionLibModelFileName.rawValue) as! String
        sceneModelFileName = aDecoder.decodeObject(forKey: CodingKeys.sceneModelFileName.rawValue) as! String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(previewImageFileName, forKey: CodingKeys.previewImageFileName.rawValue)
        aCoder.encode(visionLibModelFileName, forKey: CodingKeys.visionLibModelFileName.rawValue)
        aCoder.encode(sceneModelFileName, forKey: CodingKeys.sceneModelFileName.rawValue)
    }

    override func isEqual(_ object: Any?) -> Bool {
        var isEqual = false

        if let meeplePattern = object as? MeeplePattern {
            isEqual = previewImageFileName == meeplePattern.previewImageFileName
        }

        return isEqual
    }
}
