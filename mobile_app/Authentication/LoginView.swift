// https://posturenet.app/blog/object-recognition-with-coreml-vision-and-swiftui-on-ios/
//
//  LoginView.swift
//  Project_GOAT
//
//  Created by Trevor Leach on 7/26/23.
//

import SwiftUI
import Firebase

struct LoginPage: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var wrongEmail = 0
    @State private var wrongPassword = 0
    @State private var userIsLoggedIn = false
    @State private var showSignUp = false
    @State private var offlineMode = false
        
    var body: some View {
        if userIsLoggedIn {
            ImageSelectionView(classifier: ImageClassifier())
        } else {
            content
        }
    }
    
    var content: some View {
        NavigationStack {
            ZStack {
                Color.brown.ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack {
                    Image("goat_home")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                        .cornerRadius(10)
                    Text("Billy Cam")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .foregroundColor(.black)
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongEmail))
                        .foregroundColor(.black)
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                        .foregroundColor(.black)
                    Button {
                        login()
                    } label: {
                        Text("Login")
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.brown)
                    .cornerRadius(10)
                    
                    Button("Sign Up") {
                        showSignUp.toggle()
                    }
                    .frame(height: 50)
                    .foregroundColor(.brown)
                    .navigationDestination(isPresented: $showSignUp) {
                        SignUpView()
                    }
                    
                    Button("Offline Mode") {
                        offlineMode.toggle()
                    }
                    .frame(height: 30)
                    .foregroundColor(.brown)
                    .navigationDestination(isPresented: $offlineMode) {
                        ImageSelectionView(classifier: ImageClassifier())
                    }
                }
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            } else if let user = result?.user{
                userIsLoggedIn.toggle()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {

    static var previews: some View {
        LoginPage()
    }
}

