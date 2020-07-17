//
//  MeepleDeploymentState.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 07.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class MeepleDeploymentState: GameState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WaitForOpponentState.Type
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        guide.set(text: "Please deploy your meeple on the marked game field.")

        scene.mark(gameField: scene.player.meeple.gameField)
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)

        if let (gameField, relativeTransform) = scene.getMeeplePosition() {
            if !scene.player.meeple.isDeployed && scene.player.meeple.gameField == gameField {
                guide.set(text: "Your meeple has been successfully deployed.")

                scene.player.meeple.transformRelativeToGameField = relativeTransform

                send(player: scene.player)

                enterNextStateIfAllMeeplesAreDeployed()
            }
        }
    }

    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)

        scene.unmark(gameField: scene.player.meeple.gameField)
    }

    override func receive(player: Player) {
        super.receive(player: player)

        scene.match.set(player: player)

        enterNextStateIfAllMeeplesAreDeployed()
    }

    private func enterNextStateIfAllMeeplesAreDeployed() {
        if scene.match.areAllMeeplesDeployed {
            stateMachine?.enter(WaitForOpponentState.self)
        }
    }
}
