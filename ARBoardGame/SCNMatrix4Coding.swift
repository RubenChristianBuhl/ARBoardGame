//
//  SCNMatrix4Coding.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 08.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class SCNMatrix4Coding: NSObject, NSCoding {
    let matrix: SCNMatrix4

    enum CodingKeys: String, CodingKey {
        case m11 = "M11CodingKey"
        case m12 = "M12CodingKey"
        case m13 = "M13CodingKey"
        case m14 = "M14CodingKey"
        case m21 = "M21CodingKey"
        case m22 = "M22CodingKey"
        case m23 = "M23CodingKey"
        case m24 = "M24CodingKey"
        case m31 = "M31CodingKey"
        case m32 = "M32CodingKey"
        case m33 = "M33CodingKey"
        case m34 = "M34CodingKey"
        case m41 = "M41CodingKey"
        case m42 = "M42CodingKey"
        case m43 = "M43CodingKey"
        case m44 = "M44CodingKey"
    }

    init(_ matrix: SCNMatrix4) {
        self.matrix = matrix
    }

    required init?(coder aDecoder: NSCoder) {
        let m11 = aDecoder.decodeFloat(forKey: CodingKeys.m11.rawValue)
        let m12 = aDecoder.decodeFloat(forKey: CodingKeys.m12.rawValue)
        let m13 = aDecoder.decodeFloat(forKey: CodingKeys.m13.rawValue)
        let m14 = aDecoder.decodeFloat(forKey: CodingKeys.m14.rawValue)
        let m21 = aDecoder.decodeFloat(forKey: CodingKeys.m21.rawValue)
        let m22 = aDecoder.decodeFloat(forKey: CodingKeys.m22.rawValue)
        let m23 = aDecoder.decodeFloat(forKey: CodingKeys.m23.rawValue)
        let m24 = aDecoder.decodeFloat(forKey: CodingKeys.m24.rawValue)
        let m31 = aDecoder.decodeFloat(forKey: CodingKeys.m31.rawValue)
        let m32 = aDecoder.decodeFloat(forKey: CodingKeys.m32.rawValue)
        let m33 = aDecoder.decodeFloat(forKey: CodingKeys.m33.rawValue)
        let m34 = aDecoder.decodeFloat(forKey: CodingKeys.m34.rawValue)
        let m41 = aDecoder.decodeFloat(forKey: CodingKeys.m41.rawValue)
        let m42 = aDecoder.decodeFloat(forKey: CodingKeys.m42.rawValue)
        let m43 = aDecoder.decodeFloat(forKey: CodingKeys.m43.rawValue)
        let m44 = aDecoder.decodeFloat(forKey: CodingKeys.m44.rawValue)

        matrix = SCNMatrix4(m11: m11, m12: m12, m13: m13, m14: m14, m21: m21, m22: m22, m23: m23, m24: m24, m31: m31, m32: m32, m33: m33, m34: m34, m41: m41, m42: m42, m43: m43, m44: m44)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(matrix.m11, forKey: CodingKeys.m11.rawValue)
        aCoder.encode(matrix.m12, forKey: CodingKeys.m12.rawValue)
        aCoder.encode(matrix.m13, forKey: CodingKeys.m13.rawValue)
        aCoder.encode(matrix.m14, forKey: CodingKeys.m14.rawValue)
        aCoder.encode(matrix.m21, forKey: CodingKeys.m21.rawValue)
        aCoder.encode(matrix.m22, forKey: CodingKeys.m22.rawValue)
        aCoder.encode(matrix.m23, forKey: CodingKeys.m23.rawValue)
        aCoder.encode(matrix.m24, forKey: CodingKeys.m24.rawValue)
        aCoder.encode(matrix.m31, forKey: CodingKeys.m31.rawValue)
        aCoder.encode(matrix.m32, forKey: CodingKeys.m32.rawValue)
        aCoder.encode(matrix.m33, forKey: CodingKeys.m33.rawValue)
        aCoder.encode(matrix.m34, forKey: CodingKeys.m34.rawValue)
        aCoder.encode(matrix.m41, forKey: CodingKeys.m41.rawValue)
        aCoder.encode(matrix.m42, forKey: CodingKeys.m42.rawValue)
        aCoder.encode(matrix.m43, forKey: CodingKeys.m43.rawValue)
        aCoder.encode(matrix.m44, forKey: CodingKeys.m44.rawValue)
    }
}
