//
//  MatchFinishState.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 13.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class MatchFinishState: GameState {
    var button: GameButton

    var navigationController: UINavigationController?

    init(scene: GameScene, connectivity: GameConnectivity, guide: GameGuide, button: GameButton, navigationController: UINavigationController?) {
        self.button = button
        self.navigationController = navigationController

        super.init(scene: scene, connectivity: connectivity, guide: guide)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        button.action = leaveMatch

        button.set(title: "Leave Match")

        if scene.match.winner?.name == scene.player.name {
            guide.set(text: "You win.")
        } else {
            guide.set(text: "You lose.")
        }

        button.show()
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    }

    func leaveMatch() {
        connectivity.disconnect()

        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
}
