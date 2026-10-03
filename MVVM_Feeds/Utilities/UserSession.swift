//
//  UserSession.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/1/26.
//

import Observation

@Observable
final class UserSession {
    static let shared = UserSession()
    
    var authToken: String?
    var isLoggedIn: Bool {
        authToken != nil
    }
    
    private init() {}
}
