//
//  NSCoderExtension.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 08.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import Foundation
import SceneKit

extension NSCoder {
    func encode(_ matrix: SCNMatrix4?, forKey key: String) {
        var matrixCoding: SCNMatrix4Coding?

        if let matrix = matrix {
            matrixCoding = SCNMatrix4Coding(matrix)
        }

        encode(matrixCoding, forKey: key)
    }

    func decodeMatrix(forKey key: String) -> SCNMatrix4? {
        let matrixCoding = decodeObject(forKey: key) as! SCNMatrix4Coding?

        return matrixCoding?.matrix
    }
}
