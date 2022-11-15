//
//  FirebaseManager.swift
//  REFIT
//
//  Created by 김동윤 on 2022/11/11.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

// Auth
class FirebaseAuthManager {
    static let userID = Auth.auth().currentUser!.uid
}

// Data base
class FirebaseFirestoreManger {
    static let db = Firestore.firestore()
}

// image storage
class FirebaseStorageManager {
    static func uploadImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = FirebaseAuthManager.userID + UUID().uuidString
        
        let firebaseReference = Storage.storage().reference().child("\(imageName)")
        firebaseReference.putData(imageData, metadata: metaData)
    }
    
    static func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let storageReference = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        storageReference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
}