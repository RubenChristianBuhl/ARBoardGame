//
//  ArucoDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 25.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import Foundation

@objc
protocol ArucoDelegate {
    func set(cameraProjectionTransformation: SCNMatrix4)
    func set(boardTransformation: SCNMatrix4, isValid: Bool)
}
