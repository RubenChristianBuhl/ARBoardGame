//
//  GameButton.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 14.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class GameButton: NSObject {
    @IBOutlet weak var button: UIButton!

    var action: (() -> Void)?

    @IBAction func action(_ sender: UIButton) {
        action?()
    }

    func set(title: String) {
        DispatchQueue.main.async {
            self.button.setTitle(title, for: .normal)
        }
    }

    func show() {
        DispatchQueue.main.async {
            self.button.isHidden = false
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.button.isHidden = true
        }
    }
}
