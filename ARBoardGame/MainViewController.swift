//
//  MainViewController.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 29.01.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var createMatchButton: UIButton!
    @IBOutlet weak var searchMatchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
            if !granted {
                self.presentCameraPermissionAlert()
            }

            self.setButtons(enabled: granted)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let matchCreationViewController = segue.destination as? MatchCreationViewController {
            matchCreationViewController.playerName = getPlayerName()
        } else if let matchSearchViewController = segue.destination as? MatchSearchViewController {
            matchSearchViewController.playerName = getPlayerName()
        }
    }

    func getPlayerName() -> String {
        var playerName = UIDevice.current.name

        if let name = nameTextField.text {
            if !name.isEmpty {
                playerName = name
            }
        }

        return playerName
    }

    func setButtons(enabled: Bool) {
        DispatchQueue.main.async {
            self.createMatchButton.isEnabled = enabled
            self.searchMatchButton.isEnabled = enabled
        }
    }

    func presentCameraPermissionAlert() {
        let alertController = UIAlertController(title: "Camera Permission Denied", message: "Please go to device settings and authorize camera usage.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        let openSettingsAction = UIAlertAction(title: "Settings", style: .default, handler: { action in
            if let openSettingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                if UIApplication.shared.canOpenURL(openSettingsURL) {
                    UIApplication.shared.open(openSettingsURL)
                }
            }
        })

        alertController.addAction(cancelAction)
        alertController.addAction(openSettingsAction)

        alertController.preferredAction = openSettingsAction

        present(alertController, animated: false, completion: nil)
    }
}
