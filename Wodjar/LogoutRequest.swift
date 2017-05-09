//
//  LogoutRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/5/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class LogoutRequest: BaseRequest {

    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
    
    override func requestURL() -> String {
        return "sign-out"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodDELETE
    }
    
}
