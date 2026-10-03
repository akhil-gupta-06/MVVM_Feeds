//
//  LoginService.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/1/26.
//

protocol LoginServiceProtocol {
    func login(username: String, password: String) async throws -> LoginServiceResponse
}

class LoginService: LoginServiceProtocol {
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = .shared) {
        self.networkClient = networkClient
    }
    
    func login(username: String, password: String) async throws -> LoginServiceResponse {
        
        let loginRequest = LoginServiceRequest(username: username, password: password)
        let loginServiceResponse: LoginServiceResponse = try await self.networkClient.makeCall(path: URLAndPathConstants.Auth.login,
                                                                                               httpMethod: "POST",
                                                                                               body: loginRequest)
        return loginServiceResponse
    }
}
