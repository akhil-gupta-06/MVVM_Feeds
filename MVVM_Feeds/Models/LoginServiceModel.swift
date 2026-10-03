//
//  LoginService.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/1/26.
//

struct LoginServiceRequest: Encodable {
    let username: String
    let password: String
}

struct LoginServiceResponse: Decodable {
    let authToken: String
}

