//
//  GameScene.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 02.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class GameScene: SCNScene, VisionLibDelegate, ArucoDelegate {
    private let cameraNode = SCNNode()
    private let lightNode = SCNNode()
    private let ambientLightNode = SCNNode()
    private let gameBoardNode = SCNNode()

    private var cameraImageTexture: MTLTexture?

    var isModelTransformationValid = false
    var isBoardTransformationValid = false

    var player: Player {
        didSet {
            remove(meeple: oldValue.meeple)
            add(meeple: player.meeple)
        }
    }

    let match: Match

    var cameraImage: UIImage? {
        var image: UIImage?

        if let texture = cameraImageTexture {
            image = UIImage(texture: texture)
        }

        return image
    }

    init(_ player: Player, _ match: Match) {
        self.player = player
        self.match = match

        super.init()

        initializeCameraNode()
        initializeLightNode()
        initializeAmbientLightNode()

        rootNode.addChildNode(cameraNode)
        rootNode.addChildNode(lightNode)
        rootNode.addChildNode(ambientLightNode)
        rootNode.addChildNode(gameBoardNode)

        add(meeple: player.meeple)
        add(gameFields: match.gameBoard.gameFields)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(cameraImage: MTLTexture) {
        cameraImageTexture = cameraImage

        background.contents = cameraImage
    }

    func set(cameraImageTransformation: SCNMatrix4) {
        background.contentsTransform = cameraImageTransformation
    }

    func set(cameraProjectionTransformation: SCNMatrix4) {
        cameraNode.camera?.projectionTransform = cameraProjectionTransformation
    }

    func set(modelTransformation: SCNMatrix4, isValid: Bool) {
        player.meeple.sceneNode.transform = modelTransformation

        isModelTransformationValid = isValid
    }

    func set(boardTransformation: SCNMatrix4, isValid: Bool) {
        if isValid {
            gameBoardNode.transform = boardTransformation

            gameBoardNode.opacity = 1
        } else {
            gameBoardNode.opacity = 0
        }

        isBoardTransformationValid = isValid
    }

    func mark(treasureGameField: GameField) {
        set(gameField: treasureGameField, color: .yellow)
    }

    func mark(path: [GameField], maxCount: Int) {
        for i in 0 ..< path.count {
            if i < maxCount {
                set(gameField: path[i], color: .green)
            } else {
                set(gameField: path[i], color: .red)
            }
        }
    }

    func unmark(path: [GameField]?) {
        if let path = path {
            for gameField in path {
                unmark(gameField: gameField)
            }
        }
    }

    func mark(gameField: GameField?) {
        set(gameField: gameField, color: .red)
    }

    func unmark(gameField: GameField?) {
        gameField?.sceneNode.opacity = 0
    }

    func getMeeplePosition() -> (gameField: GameField, relativeTransform: SCNMatrix4)? {
        var meeplePosition: (GameField, SCNMatrix4)?
        if let contactedGameField = getDistinctContactedGameField() {
            let transformRelativeToContactedGameField = getMeepleTransformRelativeTo(gameField: contactedGameField)

            meeplePosition = (contactedGameField, transformRelativeToContactedGameField)
        }

        return meeplePosition
    }

    func getMeepleTransformRelativeTo(gameField: GameField) -> SCNMatrix4 {
        return gameField.sceneNode.convertTransform(player.meeple.sceneNode.transform, from: nil)
    }

    private func set(gameField: GameField?, color: UIColor) {
        gameField?.sceneNode.geometry?.materials.first?.diffuse.contents = color
        gameField?.sceneNode.opacity = 1
    }

    private func getDistinctContactedGameField() -> GameField? {
        var distinctContactedGameField: GameField?

        let contactedGameFields = getContactedGameFields()

        if contactedGameFields.count == 1 {
            distinctContactedGameField = contactedGameFields[0]
        }

        return distinctContactedGameField
    }

    private func getContactedGameFields() -> [GameField] {
        var contactedGameFields = [GameField]()

        if isModelTransformationValid && isBoardTransformationValid {
            for gameField in match.gameBoard.gameFields {
                if let meeplePhysicsBody = player.meeple.sceneNode.physicsBody, let gameFieldPhysicsBody = gameField.sceneNode.physicsBody {
                    let contacts = physicsWorld.contactTestBetween(meeplePhysicsBody, gameFieldPhysicsBody, options: nil)

                    if contacts.count > 0 {
                        contactedGameFields.append(gameField)
                    }
                }
            }
        }

        return contactedGameFields
    }

    private func add(meeple: Meeple) {
        rootNode.addChildNode(meeple.sceneNode)
    }

    private func remove(meeple: Meeple) {
        meeple.sceneNode.removeFromParentNode()
    }

    private func add(gameFields: [GameField]) {
        for gameField in gameFields {
            gameBoardNode.addChildNode(gameField.sceneNode)
        }
    }

    private func initializeCameraNode() {
        cameraNode.camera = SCNCamera()

        cameraNode.position = SCNVector3(0, 0, 0)
    }

    private func initializeLightNode() {
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni

        lightNode.position = SCNVector3(0, 10, 10)
    }

    private func initializeAmbientLightNode() {
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
    }
}
