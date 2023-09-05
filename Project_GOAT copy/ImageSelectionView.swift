//
//  ImageSelectionView.swift
//  Project_GOAT
//
//  Created by Trevor Leach on 8/3/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import Photos

struct ImageSelectionView: View {
    @State var isPresenting: Bool = false
    @State var isPresentingPrevSubs: Bool = false
    @State var uiImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var previousSubmissions: [UIImage] = []
    @State var previousClassPredictions: [String] = []
    @State var isLoggedOut = false
    @EnvironmentObject var authManager: AuthManager
    
    @ObservedObject var classifier: ImageClassifier
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) { // Use a ZStack to layer the button
                VStack{
                    if authManager.isUserAuthenticated {
                        HStack{
                            Spacer()
                            Button("Sign Out") {
                                isLoggedOut.toggle()
                                logout()
                            }
                            .frame(height: 30)
                            .navigationDestination(isPresented: $isLoggedOut) {
                                LoginPage()
                            }
                            Spacer()
                            NavigationLink {
                                SubmissionsView()//(columns: 2)
                            } label: {
                                Text("View Previous Submissions")
                            }
                            Spacer()
                        }
                    }
                    
                    VStack{
                        let modelResult = classifier.classificationResults.first
                        Text(modelResult ?? "")
                            .font(.title)
                            .bold()
                    }
                    
                    Group {
                        if uiImage != nil {
                            Image(uiImage: uiImage!)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    
                    HStack{
                        Spacer()
                        Image(systemName: "photo")
                            .onTapGesture {
                                isPresenting = true
                                sourceType = .photoLibrary
                            }
                        Spacer()
                        Image(systemName: "camera")
                            .onTapGesture {
                                isPresenting = true
                                sourceType = .camera
                            }
                        Spacer()
                    }
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()
                    
                    .sheet(isPresented: $isPresenting){
                        ImagePicker(uiImage: $uiImage, isPresenting: $isPresenting, sourceType: $sourceType)
                            .onDisappear{
                                if uiImage != nil {
                                    classifier.detect(uiImage: uiImage!)
                                    uploadPhotoStorage(uiImage: uiImage!, classificationResults: classifier.classificationResults)
                                    if sourceType == .camera {
                                        UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
                                    }
                                }
                            }
                    }
                    .padding()
                }
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}



struct ImageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSelectionView(classifier: ImageClassifier())
    }
}
