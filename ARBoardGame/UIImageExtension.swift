//
//  UIImageExtension.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 23.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(fromImagesDirectory named: String) {
        let imagesDirectory = "Images"

        if let url = Bundle.main.url(forResource: named, withExtension: nil, subdirectory: imagesDirectory) {
            self.init(contentsOfFile: url.path)
        } else {
            return nil
        }
    }

    convenience init?(texture: MTLTexture) {
        let ciImage = CIImage(mtlTexture: texture, options: nil)

        let ciContext = CIContext(options: nil)

        if let ciImage = ciImage?.oriented(.downMirrored), let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
}
