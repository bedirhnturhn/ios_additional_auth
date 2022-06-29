//
//  MainAuthViewModel.swift
//
//  Created by Bedirhan Turhan on 13.04.2022.
//

import Foundation
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore
import CryptoKit
import AuthenticationServices
import FBSDKLoginKit

class MainAuthViewModel : MainAuthViewModelProtocol {
    
    //MARK: - Properties
    weak var delegate: MainAuthViewModelDelegate?
    var dbAuth = FirebaseAuth.Auth.auth()
    var dbFirestore = FirebaseFirestore.Firestore.firestore()
    fileprivate var currentNonce: String?
    
    
    func load() {
        print("model loaded")
    }
    
    func googleSignIn() {
        delegate?.handleViewModelOutput(.setLoading(true))
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        delegate?.showGooglePopup(config, completion: { [self] userGoogle, error in
            if let error = error {
                delegate?.handleViewModelOutput(.setLoading(false))
                delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: error.localizedDescription))
            }
            
            guard
                let authentication = userGoogle?.authentication,
                let idToken = authentication.idToken
            else {
                delegate?.handleViewModelOutput(.setLoading(false))
                delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: "Something went wrong, please try again."))
                return
            }
            
            //MARK: -Google Completed above
            
            //MARK: - Firebase Auth Part
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            dbAuth.signIn(with: credential) { authResult, error in
                if let error = error {
                    delegate?.handleViewModelOutput(.setLoading(false))
                    delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: error.localizedDescription))
                }
                
                guard let user = authResult?.user else {
                    return
                }
                
                saveToDB(user) { error in
                    if let error = error {
                        delegate?.handleViewModelOutput(.setLoading(false))
                        delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: error.localizedDescription))
                    }else{
                        delegate?.handleViewModelOutput(.setLoading(false))
                        delegate?.navigate(to: .inAppHome)
                    }
                }
                
                
            }
            
        })
        
    }
    
    func facebookSignIn() {
        delegate?.handleViewModelOutput(.setLoading(true))
    }
    
    func appleSignIn() {
        delegate?.handleViewModelOutput(.setLoading(true))
        startSignInWithAppleFlow()
    }
    
    func customLogin(){
        delegate?.navigate(to: .customLogin)
    }
    
    func appleauthorizationCompletedwithSuccess(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
              guard let nonce = currentNonce else {
                  delegate?.handleViewModelOutput(.setLoading(false))
                  delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: "Invalid state: A login callback was received, but no login request was sent."))
                  return
              }
              guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                  delegate?.handleViewModelOutput(.setLoading(false))
                  delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: "Unable to fetch identity token"))
                return
              }
              guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                  delegate?.handleViewModelOutput(.setLoading(false))
                  delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: "Unable to serialize token string from data: \(appleIDToken.debugDescription)"))
                return
              }
              // Initialize a Firebase credential.
              let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                        idToken: idTokenString,
                                                        rawNonce: nonce)
              // Sign in with Firebase.
              Auth.auth().signIn(with: credential) {[self] (authResult, error) in
                if let error = error {
                  // Error. If error.code == .MissingOrInvalidNonce, make sure
                  // you're sending the SHA256-hashed nonce as a hex string with
                  // your request to Apple.
                    delegate?.handleViewModelOutput(.setLoading(false))
                    delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: error.localizedDescription))
                  return
                }
                // User is signed in to Firebase with Apple.
                  guard let user = authResult?.user else {
                      delegate?.handleViewModelOutput(.setLoading(false))
                      delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: "Something went wrong, please try again."))
                      return
                  }
                  saveToDB(user) { error in
                      if let error = error {
                          delegate?.handleViewModelOutput(.setLoading(false))
                          delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: error.localizedDescription))
                      }else{
                          delegate?.handleViewModelOutput(.setLoading(false))
                          delegate?.navigate(to: .inAppHome)
                      }
                  }
              }
            }
    }
    
    func appleauthorizationCompletedwithError(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.handleViewModelOutput(.setLoading(false))
        delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: error.localizedDescription))
    }
    
    
    private func saveToDB(_ firebaseUser : User, completion : @escaping(_ error : Error?) -> Void){
        
        dbFirestore.collection("users").document(firebaseUser.uid).getDocument { [self] snap, err in
            if(err != nil){
                completion(err)
            }
            
            if(snap!.exists){
                completion(nil)
            }else{
                var nameArray = [String]()
                if let name = firebaseUser.displayName {
                    nameArray = name.components(separatedBy: " ")
                }
                
                var setDataDictionary = [String : Any]()
                if (nameArray.count > 2){
                    setDataDictionary = ["firstname" : nameArray[0], "lastname" : nameArray.last, "email" : firebaseUser.email, "count" : 0]
                }else if(nameArray.count == 2){
                    setDataDictionary = ["firstname" : nameArray[0], "lastname" : nameArray[1], "email" : firebaseUser.email, "count" : 0]
                }else if(nameArray.count == 0){
                    setDataDictionary = ["firstname" : " ", "lastname" : " ", "email" : firebaseUser.email, "count" : 0]
                }else if(nameArray.count == 1){
                    setDataDictionary = ["firstname" : firebaseUser.displayName, "lastname" : " ", "email" : firebaseUser.email, "count" : 0]
                }
                
                dbFirestore.collection("users").document(firebaseUser.uid).setData(setDataDictionary) { err in
                    if let err = err {
                        completion(err)
                    }else{
                        completion(nil)
                    }
                }
            }
        }
    }
    
    //MARK: - Apple sign-in funcs
    @available(iOS 13, *)
    private func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        delegate?.manageAppleAuthController(request)
    }
    
    //MARK: - Facebook login
    
    func facebookLoginResponceFunction(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            delegate?.handleViewModelOutput(.setLoading(false))
            delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: error.localizedDescription))
        }
        
        guard let accessToken = AccessToken.current?.tokenString else {
            delegate?.handleViewModelOutput(.setLoading(false))
            delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: "Something went wrong, please try again."))
            
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        
        dbAuth.signIn(with: credential) { [self]authResult, error in
            if let error = error {
                delegate?.handleViewModelOutput(.setLoading(false))
                delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: error.localizedDescription))
            }
            
            // User is signed in to Firebase with Facebook.
              guard let user = authResult?.user else {
                  delegate?.handleViewModelOutput(.setLoading(false))
                  delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: "Something went wrong, please try again."))
                  return
              }
              saveToDB(user) { error in
                  if let error = error {
                      delegate?.handleViewModelOutput(.setLoading(false))
                      delegate?.handleViewModelOutput(.showNotification(result: false, notificationText: error.localizedDescription))
                  }else{
                      delegate?.handleViewModelOutput(.setLoading(false))
                      delegate?.navigate(to: .inAppHome)
                  }
              }
            
        }
        
    }
    
    func facebookLoginLogOut(_ loginButton: FBLoginButton) {
        delegate?.handleViewModelOutput(.setLoading(false))
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
