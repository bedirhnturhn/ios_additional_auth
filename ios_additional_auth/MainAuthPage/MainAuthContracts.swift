//
//  MainAuthContracts.swift
//
//  Created by Bedirhan Turhan on 12.04.2022.
//

import Foundation
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit


protocol MainAuthViewModelProtocol {
    
    var delegate : MainAuthViewModelDelegate? {get set}
    
    func load()
    func googleSignIn()
    func facebookSignIn()
    func appleSignIn()
    func appleauthorizationCompletedwithSuccess(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    func appleauthorizationCompletedwithError(controller: ASAuthorizationController, didCompleteWithError error: Error)
    func facebookLoginResponceFunction(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?)
    func facebookLoginLogOut(_ loginButton: FBLoginButton)
}

enum MainAuthModelOutput : Equatable{
    case setLoading(Bool)
    case showNotification(result: Bool,notificationText : String)
}

enum MainAuthRoute {
    case inAppHome
    case customLogin
}

protocol MainAuthViewModelDelegate : AnyObject{
    func handleViewModelOutput(_ output: MainAuthModelOutput)
    func navigate(to route: MainAuthRoute)
    func showGooglePopup(_ config : GIDConfiguration, completion : @escaping(_ userGoogle : GIDGoogleUser?, _ error : Error?) -> Void)
    func manageAppleAuthController(_ request : ASAuthorizationAppleIDRequest)
}


