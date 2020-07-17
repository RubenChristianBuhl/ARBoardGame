//
//  SCNPhysicsBodyExtension.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 02.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import Foundation

extension SCNPhysicsBody {
    static let meepleCategoryBitMask = 1
    static let gameFieldCategoryBitMask = 2

    static let meepleBoundingBoxWidthMultiplier: CGFloat = 0.1
    static let meepleBoundingBoxHeightMultiplier: CGFloat = 2.0
    static let meepleBoundingBoxLengthMultiplier: CGFloat = meepleBoundingBoxWidthMultiplier

    class func meeple(_ boundingBox: SCNBox) -> SCNPhysicsBody {
        let meeplePhysicsBody = kinematic(withCategoryBitMask: meepleCategoryBitMask, andContactTestBitMask: gameFieldCategoryBitMask)

        meeplePhysicsBody.physicsShape = createMeeplePhysicsShape(from: boundingBox)

        return meeplePhysicsBody
    }

    class func gameField() -> SCNPhysicsBody {
        return kinematic(withCategoryBitMask: gameFieldCategoryBitMask, andContactTestBitMask: meepleCategoryBitMask)
    }

    private class func kinematic(withCategoryBitMask categoryBitMask: Int, andContactTestBitMask contactTestBitMask: Int) -> SCNPhysicsBody {
        let meeplePhysicsBody = kinematic()

        meeplePhysicsBody.categoryBitMask = categoryBitMask
        meeplePhysicsBody.contactTestBitMask = contactTestBitMask
        meeplePhysicsBody.collisionBitMask = 0

        return meeplePhysicsBody
    }

    private class func createMeeplePhysicsShape(from boundingBox: SCNBox) -> SCNPhysicsShape {
        let physicsShapeBoxWidth = boundingBox.width * meepleBoundingBoxWidthMultiplier
        let physicsShapeBoxHeight = boundingBox.height * meepleBoundingBoxHeightMultiplier
        let physicsShapeBoxLength = boundingBox.length * meepleBoundingBoxLengthMultiplier

        let physicsShapeBox = SCNBox(width: physicsShapeBoxWidth, height: physicsShapeBoxHeight, length: physicsShapeBoxLength, chamferRadius: 0)

        return SCNPhysicsShape(geometry: physicsShapeBox)
    }
}
