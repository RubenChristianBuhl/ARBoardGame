//
//  PlayerAdvertiserDelegate.swift
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 16.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

protocol PlayerAdvertiserDelegate {
    func receiveInvitation(matchConfiguration: MatchConfiguration, replyInvitation: @escaping (Bool) -> Void)
}
