//
//  GameFieldExplorationState.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 11.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class GameFieldExplorationState: GameState, GameFieldExplorerDelegate {
    static let explorationTime: TimeInterval = 5

    var remainingExplorationTime: TimeInterval = 0

    var foundEvidence: Evidence?

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        var isValidNextState: Bool

        switch stateClass {
            case is WaitForOpponentState.Type, is MatchFinishState.Type:
                isValidNextState = true
            default:
                isValidNextState = false
        }

        return isValidNextState
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        foundEvidence = nil

        remainingExplorationTime = GameFieldExplorationState.explorationTime

        scene.player.meeple.gameField.content?.explore(self)
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)

        remainingExplorationTime = remainingExplorationTime - seconds

        guide.set(text: "\(Int(remainingExplorationTime)) seconds remaining for game field exploration.")

        if remainingExplorationTime <= 0 {
            scene.match.setNextCurrentPlayer()

            send(match: scene.match)

            stateMachine?.enter(WaitForOpponentState.self)
        }
    }

    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)

        if let foundEvidence = foundEvidence {
            hide(evidence: foundEvidence)
        }
    }

    func win() {
        scene.match.winner = scene.player

        scene.mark(treasureGameField: scene.player.meeple.gameField)

        send(match: scene.match)

        stateMachine?.enter(MatchFinishState.self)
    }

    func found(evidence: Evidence) {
        scene.player.foundEvidences.append(evidence)

        show(evidence: evidence)

        foundEvidence = evidence
    }

    func show(evidence: Evidence) {
        for gameField in evidence.possibleTreasureHidingGameFields {
            scene.mark(gameField: gameField)
        }
    }

    func hide(evidence: Evidence) {
        for gameField in evidence.possibleTreasureHidingGameFields {
            scene.unmark(gameField: gameField)
        }
    }
}
