//
//  GameField.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 23.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit
import SceneKit

class GameField: GKGraphNode {
    static let sceneNodeDepth: CGFloat = 0.1

    var content: GameFieldContent?

    var sceneNode: SCNNode!

    enum CodingKeys: String, CodingKey {
        case content = "ContentCodingKey"
        case sceneNode = "SceneNodeCodingKey"
    }

    override init() {
        super.init()
    }

    init(_ corners: [CGPoint]) {
        sceneNode = GameField.createSceneNode(from: corners)

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        content = aDecoder.decodeObject(forKey: CodingKeys.content.rawValue) as! GameFieldContent?
        sceneNode = aDecoder.decodeObject(forKey: CodingKeys.sceneNode.rawValue) as! SCNNode
    }

    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)

        aCoder.encode(content, forKey: CodingKeys.content.rawValue)
        aCoder.encode(sceneNode, forKey: CodingKeys.sceneNode.rawValue)
    }

    override func cost(to node: GKGraphNode) -> Float {
        return super.cost(to: node)
    }

    override func estimatedCost(to node: GKGraphNode) -> Float {
        return super.estimatedCost(to: node)
    }

    class func createSceneNode(from corners: [CGPoint]) -> SCNNode {
        let cgPath = CGMutablePath()

        cgPath.addLines(between: corners)
        cgPath.closeSubpath()

        let bezierPath = UIBezierPath(cgPath: cgPath)

        let shape = SCNShape(path: bezierPath, extrusionDepth: sceneNodeDepth)

        let node = SCNNode(geometry: shape)

        node.physicsBody = SCNPhysicsBody.gameField()
        node.opacity = 0

        return node
    }
}
