//
//  CallManager.swift
//  NevexoFacetime
//
//  Created by Vlad Beraru on 26.04.2024.
//

import Foundation
import StreamVideo
import StreamVideoUIKit
import StreamVideoSwiftUI

class CallManager {
    static let shared = CallManager()
    
    struct Constants {
        static let userToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiQ2FkZV9Ta3l3YWxrZXIiLCJpc3MiOiJodHRwczovL3Byb250by5nZXRzdHJlYW0uaW8iLCJzdWIiOiJ1c2VyL0NhZGVfU2t5d2Fsa2VyIiwiaWF0IjoxNzE0MTI1ODc0LCJleHAiOjE3MTQ3MzA2Nzl9.20Q846-cpsKeRtPU6qRCWl3G_sO-3XDz1m_dHGviN5s"
    }
    
    private var video: StreamVideo?
    private var videoUI: StreamVideoUI?
    public private(set) var callViewModel: CallViewModel?
    
    
    struct UserCredentials {
        let user: User
        let token: UserToken
    }
    
    func setUp(email: String) {
        setUpCallViewModel()
        
        let credential = UserCredentials(
            user: .guest(email),
            token: UserToken(rawValue: Constants.userToken)
        )
        
        let video = StreamVideo(
            apiKey: "356bz7npkgxd",
            user: credential.user,
            token: credential.token) { result in
                result(.success(credential.token))
        }
        
        let videoUI = StreamVideoUI(streamVideo: video)
        
        self.video = video
        self.videoUI = videoUI
    }
    
    private func setUpCallViewModel() {
        guard callViewModel == nil else { return }
        DispatchQueue.main.async {
            self.callViewModel = CallViewModel()
        }
    }
}
