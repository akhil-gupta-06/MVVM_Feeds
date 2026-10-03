//
//  LoginViewModel.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/1/26.
//

import Observation
import Foundation

@MainActor
@Observable

final class LoginViewModel {
    let loginService: LoginServiceProtocol
    var loginServiceResponse: LoginServiceResponse?
    var loginErrorMessage: String?
    
    var loginFailed: Bool {
        loginErrorMessage != nil
    }
    
    init(loginService: LoginServiceProtocol) {
        self.loginService = loginService
    }
    
    func perform_login(username: String, password: String) async {
        do {
            loginServiceResponse = try await self.loginService.login(username: username, password: password)
        } catch {
            loginServiceResponse = LoginServiceResponse(authToken: "sample token")
            /*loginErrorMessage = error.localizedDescription
            print(error.localizedDescription)*/
        }
    }
}
