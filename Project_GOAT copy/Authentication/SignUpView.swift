//
//  SignUpView.swift
//  Project_GOAT
//
//  Created by Trevor Leach on 7/26/23.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    
    @State private var email = ""
    @State private var password1 = ""
    @State private var password2 = ""
    @State private var showHome = false
    @State private var showLanding = false
    
    var body: some View {
        if showHome {
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
                    Text("Sign Up")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .foregroundColor(.black)
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                    SecureField("Password", text: $password1)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                    SecureField("Confirm Password", text: $password2)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                    Button {
                        register()
                    } label: {
                        Text("Sign Up")
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.brown)
                    .cornerRadius(10)
                }
            }
        }
    }
    
    func register() {
        if password1 == password2 {
            Auth.auth().createUser(withEmail: email, password: password2) { result, error in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password2) { result, error in
                        if error != nil {
                            print(error!.localizedDescription)
                        } else if let user = result?.user{
                            showHome.toggle()
                        }
                    }
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
