//
//  VisionLibDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 24.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import Foundation
import SceneKit

@objc
protocol VisionLibDelegate {
    func set(cameraImage: MTLTexture)
    func set(cameraImageTransformation: SCNMatrix4)
    func set(cameraProjectionTransformation: SCNMatrix4)
    func set(modelTransformation: SCNMatrix4, isValid: Bool)
}
