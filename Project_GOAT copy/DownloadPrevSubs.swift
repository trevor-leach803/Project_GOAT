//
//  PreviousSubmissions.swift
//  Project_GOAT
//
//  Created by Trevor Leach on 8/5/23.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class ImageViewModel: ObservableObject {
            
    func retrievePhotos(completion1: @escaping (UIImage, String, Timestamp) -> Void) {
        var userFolder: String = ""
        
        let db = Firestore.firestore()
        
        if let uid = Auth.auth().currentUser?.uid {
            userFolder = uid
        }

        
        db.collection("\(userFolder)").getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                let documents = snapshot!.documents
                                
                var previousSubs = [(String, String, Timestamp)]()
                for doc in documents {
                    previousSubs.append((doc["url"] as! String, doc["classPrediction"] as! String, doc["created"] as! Timestamp))
                }
                                                
                for (path, pred, create) in previousSubs {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                                                            
                    fileRef.getData(maxSize: 20 * 1024 * 1024) { data, error in
                        if error == nil && data != nil{
                            if let image = UIImage(data: data!) {
                                completion1(image, pred, create)
                            }
                        }else{
                            print("Data not retrieved")
                            print(error!)
                        }
                    }
                }
            }
        }
    }
}
