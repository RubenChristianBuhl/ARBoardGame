//
//  MeepleMovementState.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 11.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class MeepleMovementState: GameState {
    static let maxMovedGameFieldsCount = 3

    var button: GameButton

    var meepleMovement: (path: [GameField], relativeTransform: SCNMatrix4)?

    init(scene: GameScene, connectivity: GameConnectivity, guide: GameGuide, button: GameButton) {
        self.button = button

        super.init(scene: scene, connectivity: connectivity, guide: guide)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameFieldExplorationState.Type
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        button.action = confirmMovement

        button.set(title: "Confirm Movement")
        guide.set(text: "Please move your meeple to a new game field.")
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)

        scene.unmark(path: meepleMovement?.path)

        button.hide()

        if let meeplePosition = scene.getMeeplePosition() {
            if let meeplePath = scene.player.meeple.gameField.findPath(to: meeplePosition.gameField) as? [GameField] {
                let maxMeeplePathCount = MeepleMovementState.maxMovedGameFieldsCount + 1

                meepleMovement = (meeplePath, meeplePosition.relativeTransform)

                scene.mark(path: meeplePath, maxCount: maxMeeplePathCount)

                if !meeplePath.isEmpty && meeplePath.count <= maxMeeplePathCount {
                    button.show()
                }
            }
        }
    }

    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)

        guide.hide()
        button.hide()

        scene.unmark(path: meepleMovement?.path)
    }

    func confirmMovement() {
        if let meepleMovement = meepleMovement, let meepleGameField = meepleMovement.path.last {
            scene.player.meeple.gameField = meepleGameField
            scene.player.meeple.transformRelativeToGameField = meepleMovement.relativeTransform

            stateMachine?.enter(GameFieldExplorationState.self)
        }
    }
}
