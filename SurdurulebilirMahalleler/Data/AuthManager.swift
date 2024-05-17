//
//  SessionManager.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 16.04.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import Firebase

class AuthManager {
    static let shared = AuthManager()
    let auth = Auth.auth()
    
    private init() {
    }
    
    func withGoogleSession(controller: UIViewController,_ closure: @escaping (Bool,Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: controller) { [weak self] result, error in
            guard let self else { return }
            guard error == nil else {
                closure(false, error)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                let error = NSError(domain: "SurdurulebilirMahalleler.com", code: 100, userInfo: [NSLocalizedDescriptionKey: "User or ID token is missing"])
                closure(false,error)
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            self.signInOrSignUpWithGoogle(credential: credential, closure)
            
        }
    }
    
    private func signInOrSignUpWithGoogle(credential: AuthCredential, _ closure: @escaping (Bool,Error?) -> Void) {
        Auth.auth().signIn(with: credential) { (authData, error) in
            if let error {
                closure(false,error)
            } else if let user = authData?.additionalUserInfo {
                
                guard let currentUser = Auth.auth().currentUser else {
                    closure(false,error)
                    return
                }
                
                if user.isNewUser {
                    self.createUserDocuments(firebaseUser: currentUser, closure)
                } else {
                    self.getCurrentUserDouments(userId: currentUser.uid, closure)
                }
                
            }
        }
    }
    
    func signUpWithEmail(_ fullName: String,_ email: String,_ password: String,_ closure: @escaping (Bool,Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self else {return}
            
            if let user = result?.user{
                
                self.createUserDocuments(firebaseUser: user, fullName: fullName) { status, error in
                    if status {
                        self.signInWithEmail(email, password, closure)
                    }
                }
                
            } else {
                closure(false,error)
            }
        }
    }
    
    func signInWithEmail(_ email: String,_ password: String,_ closure: @escaping (Bool,Error?) -> Void ) {
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self else {return}
            guard error == nil else {closure(false,error); return}
            guard let user = authResult?.user else {closure(false,error); return}
            
            self.getCurrentUserDouments(userId: user.uid) { status, error in
                guard error == nil else {closure(false,error); return}
                guard status else {closure(false,nil); return}
                
                closure(true, nil)
            }
        }
    }
}

//MARK: Document Post functions
extension AuthManager {
    private func createUserDocuments(firebaseUser: User,fullName: String = "",_ closure: @escaping (Bool,Error?) -> Void) {
        let id = firebaseUser.uid
        let url = firebaseUser.photoURL?.absoluteString ?? ""
        let fullName = firebaseUser.displayName ?? fullName
        let username = "".generateUsername(length: 15)
        let userRef = Network.shared.refCreate(collection: .users, uid: id)
        
        
        createPointDetailsDocument(userRef: userRef) { [weak self] (pointDetailRef, error) in
            guard let self else {return}
            
            if let error {
                closure(false,error)
                
            } else if let pointDetailRef {
                self.createUserDetailModelDocument(username: username,fullName: fullName,pointRef: pointDetailRef, firebaseUser: firebaseUser) { (userDetailRef, error) in
                    if let error {
                        closure(false, error)
                    } else if let userDetailRef {
                        
                        let user = UserModel(id: id,userDetailRef: userDetailRef, pointRef: pointDetailRef, name: fullName, username: username, profileUrl: url)
                        
                        self.createUserModelDocument(user: user, closure)
                    }
                }
            }
        }
    }
    
    private func createUserModelDocument(user: UserModel, _ closure: @escaping (Bool,Error?) -> Void) {
        user.post(to: .users) { (result:Result<UserModel, any Error>) in
            
            switch result {
            case .success(let data):
                closure(true,nil)
                UserInfo.shared.store(key: .user, value: data)
                
            case .failure(let error):
                closure(false, error)
            }
        }
    }
    
    private func createUserDetailModelDocument(username: String,fullName: String = "", pointRef: DocumentReference,firebaseUser: User,_ closure: @escaping (DocumentReference?,Error?) -> Void) {
        
        let userDetail = UserDetailModel(
            id: firebaseUser.uid,
            email: firebaseUser.email,
            phoneNumber: firebaseUser.phoneNumber,
            pointRef: pointRef, fullName: firebaseUser.displayName ?? fullName,
            username: username,
            profileImageUrl: firebaseUser.photoURL?.absoluteString
        )
        
        userDetail.post(to: .userDetails) { (result:Result<UserDetailModel, any Error>) in
            switch result {
            case .success(let data):
                let userDetailRef = Network.shared.refCreate(collection: .userDetails, uid: firebaseUser.uid)
                closure(userDetailRef, nil)
                UserInfo.shared.store(key: .userDetail, value: data)
                
            case .failure(let error):
                print(error.localizedDescription)
                closure(nil,error)
            }
        }
    }
    
    private func createPointDetailsDocument(userRef: DocumentReference,_ closure: @escaping (DocumentReference?,Error?) -> Void) {
        let pointDetail = PointDetail(userRef: userRef)
        
        pointDetail.post(to: .pointDetails) {(result:Result<PointDetail, any Error>) in
            switch result {
            case.success(let data):
                
                let pointDetailRef = Network.shared.refCreate(collection: .pointDetails, uid: pointDetail.id)
                closure(pointDetailRef,nil)
                UserInfo.shared.store(key: .pointDetail, value: data)
                
            case .failure(let error):
                print(error.localizedDescription)
                closure(nil, error)
            }
        }
    }
}

//MARK: Document Get Functions
extension AuthManager {
     func getCurrentUserDouments(userId: String, _ closure: @escaping (Bool,Error?) ->Void){
        let userRef = Network.shared.refCreate(collection: .users, uid: userId)
        
        Network.shared.getDocument(reference: userRef) {[weak self] (result: Result<UserModel?, any Error>) in
            guard let self else {return}
            
            switch result {
            case.success(let data):
                if let data {
                    UserInfo.shared.store(key: .user, value: data)
                    if let userDetailRef = data.userDetailRef, let pointDetailRef = data.pointRef {
                        self.getUserDetailDocuments(ref: userDetailRef) { status, error in
                            if let error {
                                closure(false, error)
                            } else if status {
                                self.getPointDetailDocuments(ref: pointDetailRef, closure)
                            }
                        }
                    }
                } else {
                    closure(false,DocumentError.documentIsNil)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                closure(false, error)
            }
        }
        
        
    }
    
    private func getUserDetailDocuments(ref: DocumentReference, _ closure: @escaping (Bool,Error?) ->Void) {
        Network.shared.getDocument(reference: ref) { (result: Result<UserDetailModel?, any Error>)
            in
            switch result {
            case .success(let data):
                UserInfo.shared.store(key: .userDetail, value: data)
                closure(true, nil)
            case.failure(let error):
                closure(false, error)
            }
        }
    }
    
    private func getPointDetailDocuments(ref: DocumentReference, _ closure: @escaping (Bool,Error?) ->Void) {
        Network.shared.getDocument(reference: ref) { (result: Result<PointDetail?, any Error>)
            in
            switch result {
            case .success(let data):
                UserInfo.shared.store(key: .pointDetail, value: data)
                closure(true, nil)
            case.failure(let error):
                closure(false, error)
            }
        }
    }
    
    //MARK: Document Delete Functions
    
    func deleteAccount(_ closure: @escaping(Bool, (any Error)?) -> Void) {
        
        //Auth Current User Delete
        auth.currentUser?.delete { error in
            if let error {
                closure(false, error); return
            }
            
            let network = Network.shared
            let batch = network.database.batch()
           
            guard let user: UserModel = UserInfo.shared.retrieve(key: .user) else {
                closure(false, nil); return
            }
            
            let userId = user.id
            
            //User model delete
            let userModelRef = network.refCreate(collection: .users, uid: userId)
            batch.deleteDocument(userModelRef)
            
            //User detail model delete
            guard let userDerailRef = user.userDetailRef else {closure(false, nil); return}
            batch.deleteDocument(userDerailRef)
            
            //User's pointRef delete
            guard let pointRef = user.pointRef else {closure(false, nil); return}
            batch.deleteDocument(pointRef)
            
            //User posts delete
            let collectionString = FirebaseCollections.posts.rawValue
            let collection = Network.shared.database.collection(collectionString)
            let query = collection.whereField("userReference", isEqualTo: userModelRef)
            
            query.getDocuments { snapshot, error in
                if let error {
                    closure(false, error); return
                }
                
                guard let documents = snapshot?.documents else {
                    return
                }
                
                for document in documents {
                    let documentRef = network.refCreate(collection: .posts, uid: document.documentID)
                    batch.deleteDocument(documentRef)
                }
                
                batch.commit { error in
                    if let error {
                        closure(false, error)
                    } else {
                        closure(true, nil)
                    }
                }
            }
            
        }
    }
}
