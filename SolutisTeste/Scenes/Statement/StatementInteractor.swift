//
//  StatementInteractor.swift
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

    //MARK:- Interactor Protocol - called in viewController
protocol StatementBusinessLogic {
    func doLogout(request: Statement.doLogout.Request)
    func loadUserData(request: Statement.loadUser.Request)
    func loadStatement(request: Statement.loadStatement.Request)
}
    
    //MARK:- Save data to pass in router
protocol StatementDataStore {
    var userData: UserData? {get set}
}

class StatementInteractor: StatementBusinessLogic, StatementDataStore {
   
    //MARK:- Interactor variables
    var presenter: StatementPresentationLogic?
    var worker: StatementWorker?
    var userData: UserData?
    
    //MARK:- Interactor functions (call worker/pass to presenter)
    func doLogout(request: Statement.doLogout.Request) {        
        let response = Statement.doLogout.Response()
        presenter?.presentSomething(response: response)
    }
    
    func loadUserData(request: Statement.loadUser.Request) {
        let user = Statement.loadUser.Response(user: userData!)
        presenter?.presentUserData(response: user)
    }
    
    func loadStatement(request: Statement.loadStatement.Request) {
        worker = StatementWorker()
        let token = userData?.token
        worker?.loadStatement(token: token!){ result in
            switch result {
            case.success(let result):
                let statementData = Statement.loadStatement.Response(statement: result)
                self.presenter?.presentLoadStatement(response: statementData)
                break
            case.failure(let error):
                self.presenter?.presentLoadStatementError(error.localizedDescription)
            }
        }
    }
    
}

