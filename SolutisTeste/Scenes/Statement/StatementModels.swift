//
//  StatementModels.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 16/09/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Statement {
    // MARK: Use Cases (structs)
    
    enum doLogout {
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum loadUser {
        struct Request {
        }
        
        struct Response {
            let user: UserData
        }
        
        struct ViewModel {
            let user: UserData
        }
    }
    
    enum loadStatement {
        struct Request {
        }
        
        struct Response {
            let statement: [StatementData]
        }
        
        struct ViewModel {
            let statement: [StatementData]
        }
    }
}
