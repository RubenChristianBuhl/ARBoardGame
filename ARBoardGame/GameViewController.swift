//
//  GameViewController.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 29.01.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit
import SceneKit
import MultipeerConnectivity
import GameplayKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    @IBOutlet var gameGuide: GameGuide!
    @IBOutlet var gameButton: GameButton!

    @IBOutlet weak var gameSceneView: SCNView!

    var gameScene: GameScene!

    var match: Match!

    var player: Player!

    var connectivity: GameConnectivity!

    var visionLibWrapper: VisionLibWrapper!
    var arucoWrapper: ArucoWrapper!

    var stateMachine: GKStateMachine!

    var previousUpdateTime: TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        gameScene = GameScene(player, match)

        initializeStateMachine()

        arucoWrapper = ArucoWrapper(delegate: gameScene, andArucoBoard: match.gameBoard.arucoBoard)
        visionLibWrapper = VisionLibWrapper(delegate: gameScene, cameraMatrixDelegate: arucoWrapper, andModelFileName: player.meeple.visionLibModelFileName)

        gameSceneView.scene = gameScene
        gameSceneView.isPlaying = true

//        gameSceneView.debugOptions = .showPhysicsShapes
    }

    override func viewDidLayoutSubviews() {
        arucoWrapper.setTargetViewSize(gameSceneView.frame.size)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        visionLibWrapper.shutDown()
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let timeSincePreviousUpdate = time - previousUpdateTime

        visionLibWrapper.process()
        arucoWrapper.process(gameScene.cameraImage)

        stateMachine.update(deltaTime: timeSincePreviousUpdate)

        previousUpdateTime = time
    }

    private func initializeStateMachine() {
        stateMachine = GKStateMachine(states: [
            MeepleDeploymentState(scene: gameScene, connectivity: connectivity, guide: gameGuide),
            WaitForOpponentState(scene: gameScene, connectivity: connectivity, guide: gameGuide),
            MeepleMovementState(scene: gameScene, connectivity: connectivity, guide: gameGuide, button: gameButton),
            GameFieldExplorationState(scene: gameScene, connectivity: connectivity, guide: gameGuide),
            MatchFinishState(scene: gameScene, connectivity: connectivity, guide: gameGuide, button: gameButton, navigationController: navigationController)
        ])

        stateMachine.enter(MeepleDeploymentState.self)
    }
}
