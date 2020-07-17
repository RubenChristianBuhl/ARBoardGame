//
//  Meeple.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 23.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit
import SceneKit
import SceneKit.ModelIO

class Meeple: NSObject, NSCoding {
    let visionLibModelFileName: String

    let sceneNode: SCNNode

    var gameField: GameField

    var transformRelativeToGameField: SCNMatrix4?

    var isDeployed: Bool {
        return transformRelativeToGameField != nil
    }

    enum CodingKeys: String, CodingKey {
        case visionLibModelFileName = "VisionLibModelFileNameCodingKey"
        case sceneNode = "SceneNodeCodingKey"
        case gameField = "GameFieldCodingKey"
        case transformRelativeToGameField = "TransformRelativeToGameFieldCodingKey"
    }

    init(_ visionLibModelFileName: String, _ sceneModelFileName: String, _ startField: GameField) {
        self.visionLibModelFileName = visionLibModelFileName

        sceneNode = Meeple.createSceneNode(from: sceneModelFileName)

        gameField = startField
    }

    required init?(coder aDecoder: NSCoder) {
        visionLibModelFileName = aDecoder.decodeObject(forKey: CodingKeys.visionLibModelFileName.rawValue) as! String
        sceneNode = aDecoder.decodeObject(forKey: CodingKeys.sceneNode.rawValue) as! SCNNode
        gameField = aDecoder.decodeObject(forKey: CodingKeys.gameField.rawValue) as! GameField
        transformRelativeToGameField = aDecoder.decodeMatrix(forKey: CodingKeys.transformRelativeToGameField.rawValue)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(visionLibModelFileName, forKey: CodingKeys.visionLibModelFileName.rawValue)
        aCoder.encode(sceneNode, forKey: CodingKeys.sceneNode.rawValue)
        aCoder.encode(gameField, forKey: CodingKeys.gameField.rawValue)
        aCoder.encode(transformRelativeToGameField, forKey: CodingKeys.transformRelativeToGameField.rawValue)
    }

    class func createSceneNode(from sceneModelFileName: String) -> SCNNode {
        let modelsDirectory = "Models"

        let url = Bundle.main.url(forResource: sceneModelFileName, withExtension: nil, subdirectory: modelsDirectory)!

        let asset = MDLAsset(url: url)

        let node = SCNNode(mdlObject: asset.object(at: 0))

        let nodeBoundingBox = SCNBox(min: node.boundingBox.min, max: node.boundingBox.max)

        node.physicsBody = SCNPhysicsBody.meeple(nodeBoundingBox)

        return node
    }
}
