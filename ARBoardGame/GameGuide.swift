//
//  GameGuide.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 11.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class GameGuide: NSObject {
    @IBOutlet weak var view: UIView!

    @IBOutlet weak var textView: UITextView!

    func set(text: String) {
        DispatchQueue.main.async {
            self.textView.text = text

            self.view.isHidden = false
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.view.isHidden = true
        }
    }
}
