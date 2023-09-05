//
//  CloudStorage.swift
//  Project_GOAT
//
//  Created by Trevor Leach on 8/5/23.
//

import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

func uploadPhotoStorage(uiImage: UIImage, classificationResults: [String]) {
    var userFolder: String = ""
    
    let storageRef = Storage.storage().reference()
    let imageData = uiImage.pngData()
    
    guard imageData != nil else {
        return
    }
    
    if let uid = Auth.auth().currentUser?.uid {
        userFolder = uid
    }
    
    let metadata = StorageMetadata()
    metadata.customMetadata = ["classPrediction": classificationResults.first!]
    
    let path = "\(userFolder)/\(UUID().uuidString).png"
    let fileRef = storageRef.child(path)
    
    let uploadTask = fileRef.putData(imageData!, metadata: metadata) { result, error in
        if error == nil && result != nil {
            let db = Firestore.firestore()
            db.collection("\(userFolder)").document().setData(["url": path, "classPrediction": classificationResults.first!, "created": result?.timeCreated!])
        }
    }
}
