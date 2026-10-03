//
//  LoginView.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/1/26.
//

import SwiftUI

struct LoginView: View {
    @State var isLoggedIn: Bool = false
    @State private var loginVM = LoginViewModel(loginService: LoginService())
    @State private var username: String = "abcd"
    @State private var password: String = "abcd"
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            login
        }
        .fullScreenCover(isPresented: $isLoggedIn) {
            FeedsView()
        }
        .alert("Login Failed", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Invalid username or password. Please try again.")
        }
    }
    
    var login: some View {
        VStack {
            Group {
                TextField("User name", text: $username)
                SecureField("Password", text: $password)
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            
            Button {
                login_clicked()
            } label: {
                Text("Login")
            }
        }
    }
    
    func login_clicked() {
        Task {
            await loginVM.perform_login(username: username, password: password)
            guard let authToken = loginVM.loginServiceResponse?.authToken, !authToken.isEmpty else {
                showAlert = true
                return
            }
            isLoggedIn = true
        }
    }
}

#Preview {
    @Previewable @State var isLoggedIn = false
    LoginView()
}
