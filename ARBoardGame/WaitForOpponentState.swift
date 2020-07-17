//
//  WaitForOpponentState.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 07.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class WaitForOpponentState: GameState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        var isValidNextState: Bool

        switch stateClass {
            case is MeepleMovementState.Type, is MatchFinishState.Type:
                isValidNextState = true
            default:
                isValidNextState = false
        }

        return isValidNextState
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        guide.set(text: "Wait for your opponent.")

        enterNextStateIfConditionIsSatisfied()
    }

    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)

        guide.hide()
    }

    override func receive(match: Match) {
        super.receive(match: match)

        scene.match.players = match.players
        scene.match.currentPlayer = match.currentPlayer
        scene.match.winner = match.winner

        enterNextStateIfConditionIsSatisfied()
    }

    private func enterNextStateIfConditionIsSatisfied() {
        if scene.match.winner != nil {
            stateMachine?.enter(MatchFinishState.self)
        } else if scene.player.name == scene.match.currentPlayer.name {
            stateMachine?.enter(MeepleMovementState.self)
        }
    }
}
