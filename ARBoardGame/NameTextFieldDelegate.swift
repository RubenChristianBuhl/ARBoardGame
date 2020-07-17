//
//  NameTextFieldDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 22.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit

class NameTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
