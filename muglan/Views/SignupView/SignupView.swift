//
//  SignupView.swift
//  muglan
//
//  Created by Mohit Paudyal on 5/17/24.
//
import SwiftUI

struct SignupView: View {
    
    @StateObject var viewModel = SignupViewViewModel()
    
    var body: some View {
        VStack {
            HeaderView(title: "Register", subtitle: "Get notified", angleOfRotation: -15, backgroundColor: .yellow)
            
            Form {
                Section(header: Text("Account Information")) {
                    TextField("Email Address", text: $viewModel.email_address_text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .padding()
                    
                    TextField("Username", text: $viewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .padding()
                }
                
                Section(header: Text("Personal Information")) {
                    TextField("First name", text: $viewModel.firstname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .padding()
                    
                    TextField("Last name", text: $viewModel.lastname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .padding()
                }
                
                Section(header: Text("Password")) {
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .padding()
                }
                
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: {
                        viewModel.register()
                    }) {
                        Text("Register")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(viewModel.errorMessage.isEmpty)
                
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    SignupView()
}
