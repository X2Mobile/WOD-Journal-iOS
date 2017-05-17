//
//  AuthenticationService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/28/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore

struct AuthenticationService {
    
    let remote: AuthenticationRemoteService
    
    // MARK: - Public Methods
    
    func login(with email: String?, password: String?, completion: RegularLoginCompletion?) {
        guard let email = email else {
            completion?(.failure(NSError.localError(with: "Please enter an email")))
            return
        }
        
        guard let password = password else {
            completion?(.failure(NSError.localError(with: "Please enter a password")))
            return
        }
        
        if email.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Please enter an email")))
            return
        }
        
        if password.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Please enter a password")))
            return
        }
        
        remote.regularLogin(with: email, password: password, completion: completion)
        
    }
    
    func register(with email: String?, password: String?, confirmationPassword: String?, completion: RegisterCompletion?) {
        guard let email = email else {
            completion?(.failure(NSError.localError(with: "Please enter an email")))
            return
        }
        
        guard let password = password else {
            completion?(.failure(NSError.localError(with: "Please enter a password")))
            return
        }
        
        guard let confirmationPassword = confirmationPassword else {
            completion?(.failure(NSError.localError(with: "Please enter a confirmation password")))
            return
        }
        
        if email.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Please enter an email")))
            return
        }
        
        if password.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Please enter a password")))
            return
        }
        
        if confirmationPassword.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Please enter a confirmation password")))
            return
        }
        
        if confirmationPassword != password {
            completion?(.failure(NSError.localError(with: "Password and confirmation password are not the same.")))
            return
        }
        
        remote.registerUser(with: email, password: password, completion: completion)
    }
    
    func facebookLogin(on viewController: UIViewController, with completion: FacebookLoginCompletion?) {
        let loginManager = LoginManager()
        UIApplication.shared.statusBarStyle = .default  // remove this line if not required
        loginManager.logIn([ .publicProfile,.email ], viewController: viewController) { loginResult in
            print(loginResult)
            let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,name,gender,picture"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
            request.start { (response, result) in
                switch result {
                case .success(let value):
                    self.checkFacebookCredentials(from: value.dictionaryValue, completion: completion)
                case .failed(let error):
                    completion?(.failure(error as NSError))
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func checkFacebookCredentials(from dictionary: [String: Any]?, completion: FacebookLoginCompletion?) {
        guard let dictionary = dictionary else {
            completion?(.failure(NSError.localError(with: "Invalid login. Please try again.")))
            return
        }
        
        guard let _ = dictionary["email"] as? String else {
            completion?(.failure(NSError.localError(with: "We need your email address to continue. Please try again.")))
            return
        }
        
        if AccessToken.current == nil {
            completion?(.failure(NSError.localError(with: "Error. Please try again.")))
            return
        }
        
        remote.facebookLogin(with: AccessToken.current!.authenticationToken, completion: completion)
    }
    
}
