//
//  StatementWorker.swift
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
import SVProgressHUD

class StatementWorker {
    
    func formatUserData(user: UserData) -> UserFormated {
        
        let userBalance = Utils().moneyFormatter(value: user.balance)
        let userCpf = Utils().cpfCnpjMask(cpfCnpj: user.cpf)
        let userName = user.name
        let userToken = user.token
        
        let userFormated = UserFormated(name: userName, cpf: userCpf, balance: userBalance, token: userToken)
        
        return userFormated
    }
    
    func loadStatement(token: String, completionHandler: @escaping(Result<[StatementData], Error>) -> Void) {
        
        SVProgressHUD.show()
        
        APIRequest().loadStatement(token){ result in
            switch result{
            case.success(let result):
                completionHandler(.success(result))
            case.failure(let error):
                completionHandler(.failure(error))
            }
            
        }
    }
}