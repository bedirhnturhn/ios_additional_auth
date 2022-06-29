//
//  MainAuthViewController.swift
//
//  Created by Bedirhan Turhan on 12.04.2022.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit
import SnapKit

class MainAuthViewController : UIViewController {
    
    //MARK: - Properties
    private var buttonHeight = 50
    private var buttonSpace = 12
    lazy var buttonParentViewHeight = 4*buttonHeight + 3*buttonSpace
    
    lazy var viewModel : MainAuthViewModel = {
        let vM = MainAuthViewModel()
        vM.delegate = self
        return vM
    }()
    
    //MARK: - Views
    lazy var appLogo : UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFit
        imgV.image = UIImage(named: "authLogo")
        return imgV
    }()
    
    lazy var appName : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "HelveticaNeue", size: 22)
        lbl.textColor = UIColor(red: 0.00, green: 0.29, blue: 0.68, alpha: 1.00)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.text = "Additional Auth IOS-Swift"
        return lbl
    }()
    
    lazy var buttonsParentView : UIView = {
        let vw = UIView()
        vw.frame.size = .zero
        vw.backgroundColor = .white
        return vw
    }()
    
    lazy var googleLogo : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "googleLogo")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var googleLogIn : UIView = {
        let view = UIView()
        view.layer.cornerRadius = CGFloat(buttonHeight / 2)
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var googleLogInTexts : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "HelveticaNeue", size: 15)
        lbl.text = "Continue with Google"
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy var facebookLogo : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "facebookLogo")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var facebookLogIn : UIView = {
        let view = UIView()
        view.layer.cornerRadius = CGFloat(buttonHeight / 2)
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var facebookLogInTexts : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "HelveticaNeue", size: 14)
        lbl.text = "Continue with Facebook"
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy var appleLogo : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "applelogo")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var appleLogIn : UIView = {
        let view = UIView()
        view.layer.cornerRadius = CGFloat(buttonHeight / 2)
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var appleLogInTexts : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "HelveticaNeue", size: 15)
        lbl.text = "Continue with Apple"
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    
    lazy var logInButton : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 0.00, green: 0.29, blue: 0.68, alpha: 1.00)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("LOG IN", for: .normal)
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Semibold", size: 17)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius =  CGFloat(buttonHeight / 2)
        btn.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        btn.layer.shadowColor = UIColor.lightGray.cgColor
        btn.layer.shadowRadius = 2.0
        btn.layer.shadowOpacity = 1.0
        btn.layer.masksToBounds = false
        return btn
    }()
    
    //Not appeared button just we use for click func
    let facebookLoginButtonPrivate = FBLoginButton()
    
    
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        viewModel.load()
    }
    
    private func setup(){
        view.backgroundColor = .white
        
        let googleTapG = UITapGestureRecognizer(target: self, action: #selector(googleLoginCLicked))
        let facebookTapG = UITapGestureRecognizer(target: self, action: #selector(facebookLoginClicked))
        let appleTapG = UITapGestureRecognizer(target: self, action: #selector(appleLoginClicked))
        
        googleLogIn.addGestureRecognizer(googleTapG)
        facebookLogIn.addGestureRecognizer(facebookTapG)
        appleLogIn.addGestureRecognizer(appleTapG)
        logInButton.addTarget(self, action: #selector(logInClicked), for: .touchUpInside)
        
        facebookLoginButtonPrivate.permissions = ["public_profile", "email"]
        facebookLoginButtonPrivate.delegate = self
    }
    
    //MARK: - Button Funcs
    @objc func googleLoginCLicked(){
        viewModel.googleSignIn()
    }
    
    @objc func facebookLoginClicked(){
        viewModel.facebookSignIn()
        
        facebookLoginButtonPrivate.sendActions(for: .touchUpInside)
    }
    
    @objc func appleLoginClicked(){
        viewModel.appleSignIn()
    }
    
    @objc func logInClicked(){
        viewModel.customLogin()
    }
    
    //MARK: - Layout
    private func layout(){
        view.addSubview(appLogo)
        appLogo.snp.makeConstraints { make in
            make.centerY.equalTo((view.frame.height / 5.5))
            make.width.equalTo(70)
            make.height.equalTo(70)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(appName)
        appName.snp.makeConstraints { make in
            make.top.equalTo(appLogo.snp.bottom).offset(24)
            make.width.equalToSuperview()
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(buttonsParentView)
        buttonsParentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(35)
            make.width.equalToSuperview()
            make.height.equalTo(buttonParentViewHeight)
        }
        
        //MARK: - Buttons Layout
        buttonsParentView.addSubview(googleLogIn)
        googleLogIn.snp.makeConstraints { make in
            make.top.equalTo(buttonsParentView.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(buttonHeight)
        }
        
        googleLogIn.addSubview(googleLogo)
        googleLogIn.addSubview(googleLogInTexts)
        googleLogo.snp.makeConstraints { make in
            make.top.equalTo(googleLogIn.snp.top).offset(6)
            make.bottom.equalTo(googleLogIn.snp.bottom).offset(-6)
            make.width.equalTo(buttonHeight - 12)
            make.height.equalTo(buttonHeight - 12)
            make.centerX.equalTo(30)
        }
        
        googleLogInTexts.snp.makeConstraints { make in
            make.centerY.equalTo(googleLogIn.snp.centerY)
            make.centerX.equalTo(googleLogIn.snp.centerX)
            make.left.equalTo(googleLogo.snp.right).offset(12)
            make.height.equalTo(buttonHeight - 10)
        }
        
        buttonsParentView.addSubview(facebookLogIn)
        facebookLogIn.snp.makeConstraints { make in
            make.top.equalTo(googleLogIn.snp.bottom).offset(buttonSpace)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(buttonHeight)
        }
        
        facebookLogIn.addSubview(facebookLogo)
        facebookLogIn.addSubview(facebookLogInTexts)
        facebookLogo.snp.makeConstraints { make in
            make.top.equalTo(facebookLogIn.snp.top).offset(8)
            make.bottom.equalTo(facebookLogIn.snp.bottom).offset(-8)
            make.width.equalTo(buttonHeight - 16)
            make.height.equalTo(buttonHeight - 16)
            make.centerX.equalTo(30)
        }
        
        facebookLogInTexts.snp.makeConstraints { make in
            make.centerY.equalTo(facebookLogIn.snp.centerY)
            make.centerX.equalTo(facebookLogIn.snp.centerX)
            make.left.equalTo(facebookLogo.snp.right).offset(12)
            make.height.equalTo(buttonHeight - 10)
        }
        
        buttonsParentView.addSubview(appleLogIn)
        appleLogIn.snp.makeConstraints { make in
            make.top.equalTo(facebookLogIn.snp.bottom).offset(buttonSpace)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(buttonHeight)
        }
        
        appleLogIn.addSubview(appleLogo)
        appleLogIn.addSubview(appleLogInTexts)
        appleLogo.snp.makeConstraints { make in
            make.top.equalTo(appleLogIn.snp.top).offset(8)
            make.bottom.equalTo(appleLogIn.snp.bottom).offset(-8)
            make.width.equalTo(buttonHeight - 16)
            make.height.equalTo(buttonHeight - 16)
            make.centerX.equalTo(30)
        }
        
        appleLogInTexts.snp.makeConstraints { make in
            make.centerY.equalTo(appleLogIn.snp.centerY)
            make.centerX.equalTo(appleLogIn.snp.centerX)
            make.left.equalTo(appleLogo.snp.right).offset(12)
            make.height.equalTo(buttonHeight - 10)
        }
        
        buttonsParentView.addSubview(logInButton)
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(appleLogIn.snp.bottom).offset(buttonSpace)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(buttonHeight)
        }
        
    }
}

//MARK: - ViewModel Extension
extension MainAuthViewController : MainAuthViewModelDelegate {
    
    func handleViewModelOutput(_ output: MainAuthModelOutput){
        switch output {
        case .setLoading(let bool):
            if(bool){
                self.showSpinner()
            }else{
                self.removeSpinner()
            }
        case .showNotification(let result, let notificationText):
            if(result){
                customNotification(_title: "Success", _message: notificationText, actions: nil)
            }else{
                customNotification(_title: "Error!", _message: notificationText, actions: nil)
            }
        }
    }
    
    func navigate(to route: MainAuthRoute) {
        switch route {
        case .inAppHome:
//            let vc = TabbarController()
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true ,completion: nil)
            break
        case .customLogin:
//            let vc = LoginViewController()
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
            break
        }
    }
    
    func showGooglePopup(_ config: GIDConfiguration, completion: @escaping (GIDGoogleUser?, Error?) -> Void) {
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, err in
            completion(user,err)
        }
    }
    
    func manageAppleAuthController(_ request: ASAuthorizationAppleIDRequest) {
        let authorizationController = ASAuthorizationController(authorizationRequests : [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

//MARK: - Auth Extensions
extension MainAuthViewController : ASAuthorizationControllerPresentationContextProviding , ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        viewModel.appleauthorizationCompletedwithSuccess(controller: controller, didCompleteWithAuthorization: authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        viewModel.appleauthorizationCompletedwithError(controller: controller, didCompleteWithError: error)
    }
}


extension MainAuthViewController : LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        viewModel.facebookLoginResponceFunction(loginButton, didCompleteWith: result, error: error)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        viewModel.facebookLoginLogOut(loginButton)
    }
}
